{ pkgs, ... }:

{
  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      icu # for vscode mssql extension
      stdenv.cc.cc.lib
    ];
  };
}
