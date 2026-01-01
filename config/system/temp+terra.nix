{ pkgs, ... }:

{
  #
  users.users.wietse.extraGroups = [ "media" ];
  users.groups.media.gid = 400;

  # TODO upgrade to 18 https://nixos.org/manual/nixos/stable/#module-services-postgres-upgrading
  services.postgresql.package = pkgs.postgresql_14;

  nixpkgs.config.permittedInsecurePackages = [
    "olm-3.2.16" # for conduit
  ];

  boot.kernelModules = [ "nct6775" ];

  services.apcupsd.enable = true;

  personal.web-apps = {
    actual.enable = true;
    nextcloud.enable = true;
    # forgejo.enable = true;
    zigbee2mqtt.enable = true;
    fluidd.enable = true;
  };
}
