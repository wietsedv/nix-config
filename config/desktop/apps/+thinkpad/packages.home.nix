{ pkgs, ... }:

{
  home.packages = with pkgs; [
    google-chrome
    onlyoffice-desktopeditors
    slack
    vlc
  ];
}
