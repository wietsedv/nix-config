{ pkgs, ... }:

{
  home.packages = with pkgs; [
    claude-code
    devenv
    openssh
    nil
    nixfmt
  ];
}
