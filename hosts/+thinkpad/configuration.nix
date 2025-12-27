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
  imports = recursiveImports "" ++ [ ./hardware-configuration.nix ];

  networking.hostName = "thinkpad";

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
