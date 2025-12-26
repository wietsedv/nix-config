{ pkgs, ... }:

{
  home.packages = with pkgs; [
    azure-cli
    shared-mime-info
  ];
}
