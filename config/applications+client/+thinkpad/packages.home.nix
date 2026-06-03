{ pkgs, ... }:

{
  home.packages = with pkgs; [
    azure-cli
    brightnessctl
    google-chrome
    nwg-displays
    onlyoffice-desktopeditors
    slack
    vlc
  ];
}
