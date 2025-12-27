{ lib, ... }:

let
  recursiveImports = import ../recursive-imports.nix {
    inherit lib;
    path = ../../config;
    targets = [
      "mars"
      "server"
      "nixos"
    ];
  };
in
{
  imports = recursiveImports "" ++ [ ./hardware-configuration.nix ];

  networking.hostName = "mars";

  # TODO migrate all below

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
  };

  services.btrfs.autoScrub = {
    enable = true;
    fileSystems = [
      "/"
    ];
  };
}
