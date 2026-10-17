{ config, ... }:

{
  services.audiobookshelf = {
    enable = true;
    group = "media";
  };

  systemd.services.audiobookshelf.serviceConfig.UMask = "002";

  custom.web-apps.audiobookshelf.port = config.services.audiobookshelf.port;
}
