{ lib, pkgs, ... }:

{
  nix = {
    package = pkgs.lixPackageSets.latest.lix;

    channel.enable = false;
    gc = {
      automatic = true;
      dates = lib.mkIf pkgs.stdenv.isLinux "weekly";
      options = "--delete-older-than 30d";
    };
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      trusted-users = [ "wietse" ];
    };
  };

  nixpkgs.overlays = [
    # https://search.nixos.org/packages?channel=unstable&query=lixpackagesets.latest
    (final: prev: {
      inherit (prev.lixPackageSets.latest)
        nixpkgs-review
        nix-direnv
        ;
    })
  ];

  nixpkgs.config.allowUnfree = true;
}
