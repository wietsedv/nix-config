{ lib, ... }:

let
  recursiveImports = import ../recursive-imports.nix {
    inherit lib;
    path = ../../config;
    targets = [
      "mars"
      "server"
      "nixos"
    ];
  };
in
{
  imports = recursiveImports "";

  networking.hostName = "mars";
}
