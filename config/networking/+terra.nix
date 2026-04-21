{ pkgs, ... }:

{
  networking.nat = {
    enable = true;
    externalInterface = "wan0";
    internalInterfaces = [ "lan0" ];
  };

  networking.useDHCP = false;

  services.resolved.settings.Resolve = {
    LLMNR = "false";
    MulticastDNS = "yes";
  };
  networking.firewall.interfaces."lan0".allowedUDPPorts = [ 5353 ];

  systemd.network = {
    enable = true;

    links = {
      "10-wan0" = {
        matchConfig.MACAddress = "a8:a1:59:e8:63:18";
        linkConfig.Name = "wan0";
      };
      "20-lan0" = {
        matchConfig.MACAddress = "a8:a1:59:e8:63:1b";
        linkConfig.Name = "lan0";
      };
    };

    networks = {
      "10-wan0" = {
        matchConfig.Name = "wan0";
        linkConfig.RequiredForOnline = "routable";
        DHCP = "ipv4";
      };
      "20-lan0" = {
        matchConfig.Name = "lan0";
        linkConfig.RequiredForOnline = "no";
        networkConfig.MulticastDNS = true;
        address = [ "192.168.0.1/24" ];
      };
    };
  };

  systemd.services.wan-watchdog = {
    description = "WAN watchdog — bounce wan0 on connectivity loss";
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      ExecStart = pkgs.writeShellScript "wan-watchdog" ''
        INTERFACE="wan0"
        CHECK_HOST="172.16.15.1"
        INTERVAL=10
        BOUNCE_WAIT=3

        while true; do
          if ! ping -c 2 -W 3 -I "$INTERFACE" "$CHECK_HOST" &>/dev/null; then
            echo "$(date) — network down, bouncing $INTERFACE"
            networkctl down "$INTERFACE"
            sleep "$BOUNCE_WAIT"
            networkctl up "$INTERFACE"
            sleep "$INTERVAL"
          fi
          sleep "$INTERVAL"
        done
      '';
      Restart = "always";
      RestartSec = 10;
    };
  };
}
