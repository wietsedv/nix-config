{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    htop
    jq
    nano
    nmap
    (python3.withPackages (
      ps: with ps; [
        numpy
      ]
    ))
    tldr
    unar
    wget
  ];
}
