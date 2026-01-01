{ config, ... }:

{
  networking.firewall.interfaces."lan0".allowedTCPPorts = [ 32400 ];

  services.plex = {
    enable = true;
    group = "media";
  };

  systemd.services.plex.serviceConfig.UMask = "002";

  services.traefik.dynamicConfigOptions.http = {
    routers.plex = {
      rule = "Host(`plex.${config.networking.hostName}.${config.globalDomain}`)";
      service = "plex";
    };
    services.plex.loadBalancer.servers = [
      { url = "http://127.0.0.1:${toString 32400}"; }
    ];
  };
}
