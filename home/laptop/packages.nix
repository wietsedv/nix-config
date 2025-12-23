{ pkgs, ... }:

{
  home.packages = with pkgs; [
    devenv
    openssh
    nil
  ];
}
