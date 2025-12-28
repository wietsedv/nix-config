{ ... }:

{
  fileSystems = {
    "/swap".options = [
      "noatime"
      "compress=no"
    ];
  };

  swapDevices = [
    {
      device = "/swap/swapfile";
      size = 64 * 1024;
    }
  ];
}
