{ config, pkgs, ... }:

{
  services.home-assistant = {
    enable = true;
    package = pkgs.home-assistant; # default package manually disables install check
    config = {
      # proxy
      http = {
        use_x_forwarded_for = true;
        trusted_proxies = [ "127.0.0.1" ];
      };

      # core
      automation = "!include automations.yaml";
      # config = { };
      # frontend = {
      #   extra_module_url = [ "/var/lib/hass/www/community/lovelace-card-mod/card-mod.js" ];
      # };
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
      "cast"
      "github"
      "backup"
      "esphome"
      "dhcp"
      "isal"
      "shelly"
    ];
  };

  custom.web-apps.homeassistant.port = 8123;
}
