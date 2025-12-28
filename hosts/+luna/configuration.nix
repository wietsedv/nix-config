{ lib, ... }:

let
  recursiveImports = import ../recursive-imports.nix {
    inherit lib;
    path = ../../config;
    targets = [
      "luna"
      "server"
      "nixos"
    ];
  };
in
{
  imports = recursiveImports "";

  networking.hostName = "luna";
}
