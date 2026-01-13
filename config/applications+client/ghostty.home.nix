{ pkgs, ... }:

{
  programs.ghostty = {
    enable = true;
    package = if pkgs.stdenv.isLinux then pkgs.ghostty else pkgs.ghostty-bin;
    settings = {
      app-notifications = false;

      font-family = "MesloLGS Nerd Font Mono";
      font-size = if pkgs.stdenv.isLinux then 10 else 12;
      font-thicken = true;
      font-thicken-strength = 7;

      macos-titlebar-style = "hidden";

      quit-after-last-window-closed = pkgs.stdenv.isDarwin;

      theme = "light:VS Code Light Modern,dark:VS Code Dark Modern";

      window-padding-x = 10;
      window-padding-y = 10;
    };
    themes = {
      # https://github.com/microsoft/vscode/blob/1.108.0/src/vs/workbench/contrib/terminal/common/terminalColorRegistry.ts
      # https://github.com/microsoft/vscode/blob/1.108.0/extensions/theme-defaults/themes/light_modern.json
      "VS Code Light Modern" = {
        # background = "#FFFFFF"; # editor.background (light_modern.json) [fallback from terminal.background]
        background = "#F8F8F8"; # panel.background (light_modern.json) [fallback from terminal.background]
        foreground = "#3B3B3B"; # terminal.foreground (light_modern.json)
        cursor-color = "#005FB8"; # terminalCursor.foreground (light_modern.json)
        selection-background = "#ADD6FF"; # editor.selectionBackground [fallback from terminal.selectionBackground]
        selection-foreground = "#3B3B3B"; # terminal.foreground [fallback from terminal.selectionForeground]
        palette = [
          "0=#000000"
          "1=#cd3131"
          "2=#107C10"
          "3=#949800"
          "4=#0451a5"
          "5=#bc05bc"
          "6=#0598bc"
          "7=#555555"
          "8=#666666"
          "9=#cd3131"
          "10=#14CE14"
          "11=#b5ba00"
          "12=#0451a5"
          "13=#bc05bc"
          "14=#0598bc"
          "15=#a5a5a5"
        ];
      };
      # https://github.com/microsoft/vscode/blob/1.108.0/extensions/theme-defaults/themes/dark_modern.json
      "VS Code Dark Modern" = {
        # background = "#1F1F1F"; # editor.background (dark_modern.json) [fallback from terminal.background]
        background = "#181818"; # panel.background (dark_modern.json) [fallback from terminal.background]
        foreground = "#CCCCCC"; # terminal.foreground (dark_modern.json)
        cursor-color = "#CCCCCC"; # terminal.foreground (dark_modern.json) [fallback from terminalCursor.foreground]
        selection-background = "#264F78"; # editor.selectionBackground [fallback from terminal.selectionBackground]
        selection-foreground = "#CCCCCC"; # terminal.foreground [fallback from terminal.selectionForeground]
        palette = [
          "0=#000000"
          "1=#cd3131"
          "2=#0DBC79"
          "3=#e5e510"
          "4=#2472c8"
          "5=#bc3fbc"
          "6=#11a8cd"
          "7=#e5e5e5"
          "8=#666666"
          "9=#f14c4c"
          "10=#23d18b"
          "11=#f5f543"
          "12=#3b8eea"
          "13=#d670d6"
          "14=#29b8db"
          "15=#e5e5e5"
        ];
      };
    };
  };
}
