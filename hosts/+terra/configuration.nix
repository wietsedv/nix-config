{ lib, ... }:

let
  recursiveImports = import ../recursive-imports.nix {
    inherit lib;
    path = ../../config;
    targets = [
      "terra"
      "server"
      "nixos"
    ];
  };
in
{
  imports = recursiveImports "" ++ [ ./hardware-configuration.nix ];

  networking.hostName = "terra";

  # TODO migrate all below

  users.users.wietse.extraGroups = [ "media" ];
  users.groups.media.gid = 400;

  fileSystems = {
    "/btr_pool".options = [
      "noatime"
      "compress=zstd"
    ];
    "/".options = [
      "noatime"
      "compress=zstd"
    ];
    "/home".options = [
      "noatime"
      "compress=zstd"
    ];
    "/nix".options = [
      "noatime"
      "compress=zstd"
    ];
    "/var/log".options = [
      "noatime"
      "compress=zstd"
    ];

    "/data".options = [
      "noatime"
      "compress=zstd"
    ];
  };

  services.btrfs.autoScrub = {
    enable = true;
    fileSystems = [
      "/"
      "/data"
    ];
  };

  boot.kernelModules = [ "nct6775" ];

  services.apcupsd.enable = true;
}
