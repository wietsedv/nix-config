{ pkgs, ... }:

{
  home.packages = with pkgs; [
    nil
    nixd
    nixfmt
  ];

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
}
