{ config, ... }:

{
  # Chat frontend for OpenAI-compatible backends. The initial connection is the
  # Hermes API server; OPENAI_API_KEY must equal API_SERVER_KEY in
  # /var/lib/hermes/hermes.env. Connection settings are persisted in the
  # database after first start; later changes (and extra backends) go through
  # Admin Settings -> Connections, not these variables.
  services.open-webui = {
    enable = true;
    port = 8090;
    environmentFile = "/var/lib/open-webui.env";
    environment = {
      # Option default, dropped once the attrset is set.
      SCARF_NO_ANALYTICS = "True";
      DO_NOT_TRACK = "True";
      ANONYMIZED_TELEMETRY = "False";

      WEBUI_URL = "https://chat.${config.networking.hostName}.${config.globalDomain}";
      ENABLE_OLLAMA_API = "False";
      OPENAI_API_BASE_URL = "http://127.0.0.1:8642/v1";
    };
  };

  custom.web-apps.chat.port = config.services.open-webui.port;
}
