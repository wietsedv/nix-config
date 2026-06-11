{ config, pkgs, ... }:

{
  services.uptime-kuma = {
    enable = true;
    settings = {
      PORT = toString 3001;
    };
  };

  systemd.services.uptime-kuma.path = with pkgs; [ tailscale ];

  custom.web-apps.kuma.port = builtins.fromJSON config.services.uptime-kuma.settings.PORT;
}
