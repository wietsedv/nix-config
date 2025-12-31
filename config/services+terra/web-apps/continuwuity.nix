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

  services.traefik.dynamicConfigOptions.http = {
    routers.continuwuity = {
      rule = "Host(`continuwuity.${config.networking.hostName}.${config.globalDomain}`)";
      service = "continuwuity";
    };
    services.continuwuity.loadBalancer.servers = [
      { url = "http://127.0.0.1:${toString config.services.matrix-continuwuity.settings.global.port}"; }
    ];
  };
}
