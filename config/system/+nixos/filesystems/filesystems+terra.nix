{ ... }:

{
  fileSystems = {
    "/data".options = [
      "noatime"
      "compress=zstd"
    ];
  };

  services.btrfs.autoScrub.fileSystems = [ "/data" ];
}
