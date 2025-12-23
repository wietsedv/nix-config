{ ... }:

{
  imports = [
    ../../system/+macbook
    ../../system/common
  ];

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
        imports = [
          ../../home/+macbook
          ../../home/laptop
        ];
        home.stateVersion = "25.05";
      };
  };

  system.stateVersion = 6;
}
