{ pkgs, ... }:

{
  home.packages = with pkgs; [
    azure-cli
    brightnessctl
    google-chrome
    nautilus
    nwg-displays
    onlyoffice-desktopeditors
    slack
    vlc
  ];
}
