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
      # On darwin, hardlinking into /nix/store/.links makes TCC resolve binaries (e.g. skhd) to
      # that 300k-entry directory, and every permission check through them stalls for seconds.
      auto-optimise-store = pkgs.stdenv.hostPlatform.isLinux;
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      trusted-users = [ "wietse" ];
    };
  };

  nixpkgs.config.allowUnfree = true;
}
