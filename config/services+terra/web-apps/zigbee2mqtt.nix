{ config, ... }:

{
  services.zigbee2mqtt = {
    enable = true;

    settings = {
      frontend.port = 8085;
      serial = {
        adapter = "ember";
        port = "/dev/serial/by-id/usb-ITEAD_SONOFF_Zigbee_3.0_USB_Dongle_Plus_V2_20230221081729-if00";
      };

      mqtt.version = 5;
      advanced = {
        channel = 25;
        last_seen = "ISO_8601";
        legacy_api = false; # TODO remove
        legacy_availability_payload = false; # TODO remove
        log_level = "warning";
      };
      availability = true;

      devices = "devices.yaml";
      groups = "groups.yaml";
    };
  };

  custom.web-apps.zigbee2mqtt.port = config.services.zigbee2mqtt.settings.frontend.port;
}
