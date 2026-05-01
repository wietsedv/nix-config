{ config, ... }:

{
  services.searx = {
    enable = true;

    environmentFile = "/var/lib/searx/searx.env";

    settings = {
      server.port = 8081;
      server.secret_key = "$SEARX_SECRET_KEY";
    };
  };

  custom.web-apps.searx.port = config.services.searx.settings.server.port;
}
