{ config, ... }:

{
  services.immich = {
    enable = true;
    host = "127.0.0.1";
    accelerationDevices = null;
  };

  users.users.immich.extraGroups = [
    "video"
    "render"
  ];

  custom.web-apps.immich.port = config.services.immich.port;
}
