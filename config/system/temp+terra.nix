{ pkgs, ... }:

{
  # TODO upgrade to 18 https://nixos.org/manual/nixos/stable/#module-services-postgres-upgrading
  services.postgresql.package = pkgs.postgresql_14;

  boot.kernelModules = [ "nct6775" ];

  services.apcupsd.enable = true;

  personal.web-apps = {
    actual.enable = true;
    nextcloud.enable = true;
    zigbee2mqtt.enable = true;
    fluidd.enable = true;
  };
}
