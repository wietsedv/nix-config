{ pkgs, ... }:

{
  programs.ghostty = {
    enable = true;
    package = if pkgs.stdenv.isLinux then pkgs.ghostty else pkgs.ghostty-bin;
    settings = {
      app-notifications = false;

      font-family = "MesloLGS Nerd Font Mono";
      font-size = if pkgs.stdenv.isLinux then 10 else 12;

      macos-titlebar-style = "hidden";

      quit-after-last-window-closed = pkgs.stdenv.isDarwin;

      theme = "light:Adwaita,dark:Adwaita Dark";

      window-padding-balance = true;
      window-padding-x = 10;
      window-padding-y = 10;
    };
  };
}
