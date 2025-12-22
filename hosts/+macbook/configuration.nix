{ ... }:

{
  imports = [
    ../common.nix
    ./nix-darwin
  ];

  networking.hostName = "macbook";

  users.users.wietse = {
    home = "/Users/wietse";
  };

  system.primaryUser = "wietse";

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.wietse = ../../home/+macbook/home.nix;
  };

  system.stateVersion = 6;
}
