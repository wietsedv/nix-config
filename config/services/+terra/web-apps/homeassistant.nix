{ pkgs, ... }:

{
  services.home-assistant = {
    enable = true;
    package = pkgs.home-assistant; # default package manually disables install check
    config = {
      # core
      automation = "!include automations.yaml";
      scene = "!include scenes.yaml";
      script = "!include scripts.yaml";

      # extra
      history = { };
      homeassistant_alerts = { };
      logbook = { };
      # map = { };
      mobile_app = { };
      my = { };
      person = { };
      python_script = { };
      recorder = {
        purge_keep_days = 14;
        exclude.domains = [
          "automation"
          "update"
        ];
      };
      sun = { };
      system_health = { };
      zone = { };

      # input/helpers
      counter = { };
      image_upload = { };
      input_boolean = { };
      input_button = { };
      input_datetime = { };
      input_number = { };
      input_select = { };
      input_text = { };
      timer = { };
    };
    extraComponents = [
      "mqtt"
      "github"
      "backup"
      "esphome"
      "dhcp"
      "isal"
      "shelly"
      "apcupsd"
      "mcp_server"
    ];
  };

  custom.web-apps.homeassistant.port = 8123;
}
