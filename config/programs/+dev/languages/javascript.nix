{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    bun
    nodejs_26
    yarn
  ];
}
