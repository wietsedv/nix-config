{ config, ... }:

let
  terra = "10.10.10.2";
in
{
  systemd.network = {
    networks."50-wg0" = {
      matchConfig.Name = "wg0";
      address = [ "${terra}/32" ];
    };

    netdevs."50-wg0" = {
      netdevConfig = {
        Kind = "wireguard";
        Name = "wg0";
      };

      wireguardConfig = {
        ListenPort = 51820;
        PrivateKeyFile = "/var/lib/wireguard/private";
        FirewallMark = 42;
      };

      wireguardPeers = [
        {
          PublicKey = "H3tMRvYcvpSxkrkz1vN9wivDBs4ujW6cZrzX5pwxEEQ=";
          AllowedIPs = [ "0.0.0.0/0" ];
          Endpoint = "luna.${config.globalDomain}:51820";
        }
      ];
    };
  };

  networking.firewall.checkReversePath = "loose";
}
