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
    (python3.withPackages (
      ps: with ps; [
        numpy
        pandas
        openpyxl
      ]
    ))
    tldr
    tmux
    unar
    wget
  ];
}
