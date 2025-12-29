{ ... }:

let
  luna = "10.10.10.1";
  terra = "10.10.10.2";
in
{
  networking.firewall = {
    allowedUDPPorts = [ 51820 ];
    # trustedInterfaces = [ "wg0" ];
  };

  # disable legacy option
  networking.useDHCP = false;

  systemd.network = {
    enable = true;

    networks = {
      "10-ens3" = {
        matchConfig.Name = "ens3";
        DHCP = "yes";
      };
      "50-wg0" = {
        matchConfig.Name = "wg0";
        address = [ "${luna}/32" ];

        networkConfig = {
          IPv4Forwarding = true;
          IPv6Forwarding = true;
        };
      };
    };

    netdevs."50-wg0" = {
      netdevConfig = {
        Kind = "wireguard";
        Name = "wg0";
      };

      wireguardConfig = {
        ListenPort = 51820;
        PrivateKeyFile = "/var/lib/wireguard/private";
        RouteTable = "main";
        FirewallMark = 42;
      };

      wireguardPeers = [
        {
          PublicKey = "V9G7LpMaPk1pEgHCP2sDW4yfy3vfdOtypf4EmNcZflA=";
          AllowedIPs = [ "${terra}/32" ];
        }
      ];
    };

  };

  networking.nat = {
    enable = true;
    externalInterface = "ens3";
    internalInterfaces = [ "wg0" ];

    forwardPorts = [
      {
        sourcePort = 51572;
        proto = "tcp";
        destination = "${terra}:51572";
      }
      {
        sourcePort = 51572;
        proto = "udp";
        destination = "${terra}:51572";
      }
    ];
  };
}
