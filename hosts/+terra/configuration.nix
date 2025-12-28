{ lib, pkgs, ... }:

let
  recursiveImports = import ../recursive-imports.nix {
    inherit lib;
    path = ../../config;
    targets = [
      "terra"
      "server"
      "nixos"
    ];
  };
in
{
  imports = recursiveImports "";
}
