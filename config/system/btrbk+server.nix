{
  config,
  lib,
  pkgs,
  ...
}:

let
  # transfer snapshots to target host
  targets = {
    terra = "mars";
    mars = "terra";
  };

  # receive snapshots from hosts with authorized public keys
  sources = {
    terra = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJeyqjB+zx+3TRQv3Nej4iT89gu0ii6Kxiy94Vs2rbQ6 btrbk@mars"
    ];
    mars = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPoE/A3o+Kf0LAJdxIKKsxYpR2HDloOESt6GTHgCEhor btrbk@terra"
    ];
  };

  hostName = config.networking.hostName;
in
lib.mkIf (targets ? hostName || sources ? hostName) {
  services.btrbk = {
    extraPackages = [ pkgs.lz4 ];
    instances.btrbk = lib.mkIf (targets ? hostName) {
      onCalendar = "daily";
      settings = {
        snapshot_preserve_min = "latest";
        snapshot_preserve = "14d";

        ssh_user = "btrbk";
        ssh_identity = "/var/lib/btrbk/.ssh/id_ed25519"; # TODO secret
        stream_compress = "lz4";

        target_preserve_min = "latest";
        target_preserve = "14d";

        volume."/btr_pool" = {
          subvolume = "root";
          snapshot_dir = "btr_snapshots";
          target = "ssh://${targets.${hostName}}/btr_pool/btr_backups/${hostName}";
        };
      };
    };
    sshAccess = builtins.map (key: {
      inherit key;
      roles = [
        "target"
        "delete"
      ];
    }) sources;
  };
}
