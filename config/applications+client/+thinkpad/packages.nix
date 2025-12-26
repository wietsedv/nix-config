{ pkgs, ... }:

{
  home.packages = with pkgs; [
    brightnessctl
    gnome-font-viewer
    gnome-system-monitor
    libreoffice
    nwg-displays
    nautilus
    slack
    ungoogled-chromium
    vlc
  ];
}
