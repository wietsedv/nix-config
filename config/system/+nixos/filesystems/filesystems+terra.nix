{ ... }:

{
  fileSystems = {
    "/data".options = [
      "noatime"
      "compress=zstd"
    ];
  };
}
