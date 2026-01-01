{ ... }:

{
  networking.firewall.interfaces."lan0".allowedTCPPorts = [ 32400 ];

  services.plex = {
    enable = true;
    group = "media";
  };

  systemd.services.plex.serviceConfig.UMask = "002";

  custom.web-apps.plex.port = 32400;
}
