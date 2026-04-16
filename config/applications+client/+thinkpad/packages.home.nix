{ pkgs, ... }:

{
  home.packages = with pkgs; [
    brightnessctl
    google-chrome
    nwg-displays
    nautilus
    onlyoffice-desktopeditors
    slack
    vlc
  ];
}
