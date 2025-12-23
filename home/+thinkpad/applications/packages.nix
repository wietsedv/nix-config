{ pkgs, ... }:

{
  home.packages = with pkgs; [
    azure-cli
    shared-mime-info

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
