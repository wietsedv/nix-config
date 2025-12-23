{ ... }:

{
  imports = [
    ../../system/+thinkpad
    ../../system/common
    ./hardware-configuration.nix
  ];

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
        imports = [
          ../../home/+thinkpad
          ../../home/laptop
        ];
        home.stateVersion = "25.05";
      };
  };

  system.stateVersion = "25.05";
}
