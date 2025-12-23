{ lib, pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    historySubstringSearch.enable = true;
  };

  programs.starship = lib.mkIf pkgs.stdenv.isDarwin {
    enable = true;
  };
}
