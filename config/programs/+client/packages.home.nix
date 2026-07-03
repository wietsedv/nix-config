{ pkgs, ... }:

{
  home.packages = with pkgs; [
    glab
    nil
    nixd
    nixfmt
  ];

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
}
