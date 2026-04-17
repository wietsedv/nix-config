{ pkgs, ... }:

{
  home.packages = with pkgs; [
    openssh
    nil
    nixfmt
  ];

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
}
