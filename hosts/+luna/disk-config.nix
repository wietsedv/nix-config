{
  disko.devices.disk = {
    root = {
      type = "disk";
      device = "/dev/sda";
      content = {
        type = "gpt";
        partitions = {
          boot = {
            name = "boot";
            size = "1M";
            type = "EF02";
          };
          esp = {
            name = "ESP";
            size = "512M";
            type = "EF00";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
            };
          };
          root = {
            size = "100%";
            content = {
              type = "btrfs";
              extraArgs = [ "-f" ];
              mountpoint = "/btr_pool";
              mountOptions = [
                "noatime"
                "compress=zstd"
              ];
              subvolumes = {
                "root" = {
                  mountOptions = [
                    "noatime"
                    "compress=zstd"
                  ];
                  mountpoint = "/";
                };
                "home" = {
                  mountOptions = [
                    "noatime"
                    "compress=zstd"
                  ];
                  mountpoint = "/home";
                };
                "nix" = {
                  mountOptions = [
                    "noatime"
                    "compress=zstd"
                  ];
                  mountpoint = "/nix";
                };
                "var/log" = {
                  mountOptions = [
                    "noatime"
                    "compress=zstd"
                  ];
                  mountpoint = "/var/log";
                };
              };
            };
          };
        };
      };
    };
  };
}
