{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    bun
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
    unar
    wget
    yarn
  ];
}
