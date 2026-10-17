{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    curl
    ffmpeg
    gnumake
    htop
    jq
    nano
    nmap
    tldr
    tmux
    wget
  ];
}
