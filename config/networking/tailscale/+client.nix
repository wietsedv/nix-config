{ lib, pkgs, ... }:

{
  services.tailscale =
    if pkgs.stdenv.isLinux then
      {
        enable = true;
        openFirewall = true;
        useRoutingFeatures = "client";
      }
    else
      { };

  homebrew = lib.mkIf pkgs.stdenv.isDarwin { casks = [ "tailscale-app" ]; };
}
