{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    bun
    htop
    jq
    bun
    nano
    nmap
    nodejs_24
    tldr
    tmux
    unar
    wget
    icu
  ];
}
