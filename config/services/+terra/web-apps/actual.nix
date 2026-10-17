{ config, ... }:

{
  services.actual = {
    enable = true;
  };

  custom.web-apps.actual.port = config.services.actual.settings.port;
}
