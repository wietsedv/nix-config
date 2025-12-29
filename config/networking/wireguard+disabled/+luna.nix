{ config, pkgs, ... }:

{
  networking = {
    firewall = {
      allowedUDPPorts = [ config.networking.wireguard.interfaces."wg0".listenPort ];
      trustedInterfaces = [ "wg0" ];
    };

    nat = {
      enable = true;
      externalInterface = "ens3";
      internalInterfaces = [ "wg0" ];
      forwardPorts = [
        {
          sourcePort = 51572;
          proto = "tcp";
          destination = "10.10.10.2:51572";
        }
        {
          sourcePort = 51572;
          proto = "udp";
          destination = "10.10.10.2:51572";
        }
      ];
    };

    wireguard.interfaces."wg0" = {
      ips = [ "10.10.10.1/24" ];
      listenPort = 51820;
      postSetup = ''
        ${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -s 10.10.10.0/24 -o ens3 -j MASQUERADE
      '';
      postShutdown = ''
        ${pkgs.iptables}/bin/iptables -t nat -D POSTROUTING -s 10.10.10.0/24 -o ens3 -j MASQUERADE
      '';
      privateKeyFile = "/var/lib/wireguard/private";

      peers = [
        {
          name = "terra";
          publicKey = "V9G7LpMaPk1pEgHCP2sDW4yfy3vfdOtypf4EmNcZflA=";
          allowedIPs = [ "10.10.10.2/32" ];
        }
      ];
    };
  };
}
