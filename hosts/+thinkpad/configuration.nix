{ lib, ... }:

let
  recursiveImports = import ../recursive-imports.nix {
    inherit lib;
    path = ../../config;
    targets = [
      "thinkpad"
      "client"
    ];
  };
in
{
  imports = [ ./hardware-configuration.nix ] ++ recursiveImports "";

  networking.hostName = "thinkpad";

  users.users.wietse = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
  };

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

  time.timeZone = "Europe/Amsterdam";

  system.stateVersion = "25.05";
}
