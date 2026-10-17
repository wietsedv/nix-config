{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    cargo
    clippy
    rust-analyzer
    rustc
    rustfmt
  ];
}
