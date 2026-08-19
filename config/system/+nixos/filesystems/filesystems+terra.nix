{ ... }:

{
  fileSystems = {
    "/data".options = [
      "noatime"
      "compress=zstd"
    ];
    "/swap".options = [
      "noatime"
      "compress=no"
    ];
  };

  swapDevices = [
    {
      device = "/swap/swapfile";
      size = 32 * 1024;
    }
  ];

  services.btrfs.autoScrub.fileSystems = [ "/data" ];
}
