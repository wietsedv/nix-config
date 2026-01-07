{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    htop
    jq
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
    unar
    wget
  ];
}
