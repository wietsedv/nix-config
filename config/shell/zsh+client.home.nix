{ pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    historySubstringSearch.enable = true;

    shellAliases = {
      ter = "ssh terra";
      mar = "ssh mars";
      lun = "ssh luna";

      nf = "nix flake update";
      nfs = "nf && nr";
      nft = "nf && nrt";
    };

    initContent = ''
      _nr-sync () { rsync --delete --filter=":- .gitignore" -avh ./ "$1":/etc/nixos }

      _nr () {
        cmd="$1"
        if [ -z "$2" ]; then ${
          if pkgs.stdenv.hostPlatform.isLinux then "nixos-rebuild $cmd --sudo" else "darwin-rebuild build && sudo darwin-rebuild $cmd"
        }
        else
          _nr-sync "$2" && ssh -t "$2" nixos-rebuild $cmd --sudo
        fi
      }

      nr () { _nr switch "$1" }
      nrb () { _nr boot "$1" }
      nrt () { _nr test "$1" }
    '';
  };
}
