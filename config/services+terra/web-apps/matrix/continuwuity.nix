{ config, ... }:

{
  services.matrix-continuwuity = {
    enable = true;
    settings = {
      global = {
        server_name = "${config.globalDomain}";
        allow_registration = false;
        allow_federation = false;
        allow_announcements_check = false;
      };
    };
  };

  custom.web-apps.continuwuity.port = builtins.head config.services.matrix-continuwuity.settings.global.port;
}
