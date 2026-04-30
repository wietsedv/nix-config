{ pkgs, ... }:

{
  home.packages = with pkgs; [
    openssh
    nil
    nixd
    nixfmt
  ];

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
}
