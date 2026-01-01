{ config, pkgs, ... }:

{
  services.forgejo = {
    enable = true;
    package = pkgs.forgejo; # default package is forgejo-lts
    settings.server = {
      HTTP_PORT = 3002;
      ROOT_URL = "https://forgejo.${config.networking.hostName}.${config.globalDomain}/";
    };
  };

  custom.web-apps.forgejo.port = config.services.forgejo.settings.server.HTTP_PORT;
}
