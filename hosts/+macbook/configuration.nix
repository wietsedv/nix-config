{ lib, ... }:

let
  recursiveImports = import ../recursive-imports.nix {
    inherit lib;
    path = ../../config;
    targets = [
      "macbook"
      "client"
    ];
  };
in
{
  imports = recursiveImports "";

  networking.hostName = "macbook";

  nixpkgs.hostPlatform = "aarch64-darwin";

  users.users.wietse = {
    home = "/Users/wietse";
  };

  system.primaryUser = "wietse";

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

  system.stateVersion = 6;
}
