{ config, lib, ... }:

{
  config = {
    fileSystems = lib.mkIf (!config ? disko) {
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
  };
}
