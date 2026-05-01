{ config, ... }:

{
  services.searx = {
    enable = true;

    settings = {
      server.port = 8081;
    };
  };

  custom.web-apps.searx.port = config.services.searx.settings.server.port;
}
