{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    bun
    curl
    ffmpeg
    gnumake
    gh
    go
    htop
    jq
    nano
    nmap
    nodejs_26
    ruby
    tldr
    tmux
    wget
    yarn
  ];
}
