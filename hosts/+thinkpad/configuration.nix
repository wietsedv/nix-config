{ ... }:

{
  imports = [
    ../common.nix
    ./nixos
    ./hardware-configuration.nix
    ./networking.nix
  ];

  networking.hostName = "thinkpad";

  users.users.wietse = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
  };

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.wietse = ../../home/+thinkpad/home.nix;
  };

  system.stateVersion = "25.05";
}
