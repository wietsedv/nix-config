{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    bun
    go
    htop
    jq
    nano
    nmap
    nodejs_26
    tldr
    tmux
    unar
    wget
  ];
}
