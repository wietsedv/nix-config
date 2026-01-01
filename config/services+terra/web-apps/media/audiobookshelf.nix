{ config, ... }:

{
  services.audiobookshelf = {
    enable = true;
    group = "media";
  };

  systemd.services.audiobookshelf.serviceConfig.UMask = "002";

  services.traefik.dynamicConfigOptions.http = {
    routers.audiobookshelf = {
      rule = "Host(`audiobookshelf.${config.networking.hostName}.${config.globalDomain}`)";
      service = "audiobookshelf";
    };
    services.audiobookshelf.loadBalancer.servers = [
      { url = "http://127.0.0.1:${toString config.services.audiobookshelf.port}"; }
    ];
  };
}
