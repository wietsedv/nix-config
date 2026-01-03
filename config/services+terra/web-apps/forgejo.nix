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

  services.gitea-actions-runner = {
    package = pkgs.forgejo-runner;

    instances.${config.networking.hostName} = {
      enable = true;
      url = config.services.forgejo.settings.server.ROOT_URL;
      name = config.networking.hostName;
      tokenFile = "/var/lib/gitea-runner/token.env";

      labels = [ "nixos:host" ];
      hostPackages = with pkgs; [
        bash
        coreutils
        openssh
        nodejs
        config.nix.package
      ];
    };
  };
}
