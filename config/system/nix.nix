{ lib, pkgs, ... }:

{
  nix = {
    channel.enable = false;
    gc = {
      automatic = true;
      dates = lib.mkIf pkgs.stdenv.hostPlatform.isLinux "weekly";
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

  nixpkgs.config.allowUnfree = true;
}
