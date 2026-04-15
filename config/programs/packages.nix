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

  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      icu # for vscode mssql extension
      stdenv.cc.cc.lib
    ];
  };
}
