{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    bun
    htop
    jq
    nano
    nmap
    nodejs_24
    tldr
    tmux
    unar
    wget
  ];
}
