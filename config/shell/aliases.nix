{ pkgs, ... }:

{
  programs.zsh = {
    shellAliases = {
      ter = "ssh terra";
      mar = "ssh mars";
      lun = "ssh luna";

      nf = "nix flake update";
      nfs = "nf && nrs";
      nft = "nf && nrt";
    };
    interactiveShellInit = ''
      _nr-sync () { rsync --delete --filter=":- .gitignore" -avh ./ "$1":/etc/nixos }

      _nr () {
        cmd="$1"
        if [ -z "$2" ]; then ${
          if pkgs.stdenv.isLinux then "nixos-rebuild $cmd --sudo" else "sudo darwin-rebuild $cmd"
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
