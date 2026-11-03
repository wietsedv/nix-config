{ pkgs, ... }:

{
  home.packages = with pkgs; [
    google-chrome
    llm-agents.herdr-app
    onlyoffice-desktopeditors
    slack
    vlc
  ];
}
