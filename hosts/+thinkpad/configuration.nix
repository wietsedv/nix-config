{ lib, ... }:

let
  recursiveImports = import ../recursive-imports.nix {
    inherit lib;
    path = ../../config;
    targets = [
      "thinkpad"
      "client"
      "nixos"
    ];
  };
in
{
  imports = recursiveImports "";

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.wietse =
      { ... }:
      {
        imports = recursiveImports "home";
        home.stateVersion = "25.05";
      };
  };
}
