{ config, ... }:

{
  # Backend for Hermes Desktop on the macbook. Behind traefik, so the public
  # URL engages the dashboard auth gate; credentials live in the env file
  # (HERMES_DASHBOARD_BASIC_AUTH_{USERNAME,PASSWORD,SECRET}) with the API keys.
  services.hermes-agent = {
    enable = true;
    environmentFiles = [ "/var/lib/hermes/hermes.env" ];
    settings.dashboard.public_url = "https://hermes.${config.networking.hostName}.${config.globalDomain}";
    backend.mode = "dashboard";
  };

  custom.web-apps.hermes.port = config.services.hermes-agent.backend.port;
}
