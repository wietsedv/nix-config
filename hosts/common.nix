{ lib, pkgs, ... }:

{
  environment = {
    shellAliases = {
      ter = "ssh terra";
      mar = "ssh mars";
      lun = "ssh luna";
    };
  };

  nix = {
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

  nixpkgs.config.allowUnfree = true;

  time.timeZone = "Europe/Amsterdam";

  programs.zsh =
    if pkgs.stdenv.isLinux then
      {
        enable = true;
        autosuggestions.enable = true;
        syntaxHighlighting.enable = true;
      }
    else
      {
        enable = true;
        enableAutosuggestions = true;
        enableSyntaxHighlighting = true;
      };
}
