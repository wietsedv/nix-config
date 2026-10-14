{ config, ... }:

{
  # Backend for Hermes Desktop on the macbook. Behind traefik, so the public
  # URL engages the dashboard auth gate; credentials live in the env file
  # (HERMES_DASHBOARD_BASIC_AUTH_{USERNAME,PASSWORD,SECRET}) with the API keys.
  services.hermes-agent = {
    enable = true;
    environmentFiles = [ "/var/lib/hermes/hermes.env" ];
    # OpenAI-compatible API on 127.0.0.1:8642 for Open WebUI. Served by the
    # gateway, not the backend; needs API_SERVER_KEY (>= 16 chars) in the env file.
    environment.API_SERVER_ENABLED = "true";
    settings.dashboard.public_url = "https://hermes.${config.networking.hostName}.${config.globalDomain}";
    backend.mode = "dashboard";
  };

  custom.web-apps.hermes.port = config.services.hermes-agent.backend.port;
}
