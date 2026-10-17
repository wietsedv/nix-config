{ config, ... }:

{
  # Chat frontend for OpenAI-compatible backends. Connections are configured in
  # Admin Settings -> Connections and persisted in the database.
  services.open-webui = {
    enable = true;
    port = 8090;
    environmentFile = "/var/lib/open-webui/open-webui.env";
    environment = {
      # Option default, dropped once the attrset is set.
      SCARF_NO_ANALYTICS = "True";
      DO_NOT_TRACK = "True";
      ANONYMIZED_TELEMETRY = "False";

      WEBUI_URL = "https://chat.${config.networking.hostName}.${config.globalDomain}";
      ENABLE_OLLAMA_API = "False";
    };
  };

  custom.web-apps.chat.port = config.services.open-webui.port;
}
