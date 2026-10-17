{ config, ... }:

{
  services.vaultwarden = {
    enable = true;
    domain = "vaultwarden.${config.networking.hostName}.${config.globalDomain}";

    environmentFile = "/var/lib/vaultwarden/vaultwarden.env";

    config = {
      ROCKET_ADDRESS = "127.0.0.1";
      ROCKET_PORT = 8222;
      SIGNUPS_ALLOWED = false;
    };
  };

  custom.web-apps.vaultwarden.port = config.services.vaultwarden.config.ROCKET_PORT;
}
