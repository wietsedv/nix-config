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
      auto-optimise-store = true;
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      trusted-users = [ "wietse" ];
    };
  };

  nixpkgs.overlays = [
    (final: prev: {
      inherit (prev.lixPackageSets.latest)
        nixpkgs-review
        ;
    })
  ];

  nixpkgs.config.allowUnfree = true;
}
