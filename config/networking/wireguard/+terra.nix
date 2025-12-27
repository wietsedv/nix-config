{ ... }:

{
  networking = {
    wireguard.interfaces."wg0" = {
      ips = [ "10.10.10.2/24" ];
      privateKeyFile = "/var/lib/wireguard/private";
      allowedIPsAsRoutes = false;
      peers = [
        {
          name = "luna";
          publicKey = "H3tMRvYcvpSxkrkz1vN9wivDBs4ujW6cZrzX5pwxEEQ=";
          allowedIPs = [ "0.0.0.0/0" ];
          endpoint = "luna:51820";
          persistentKeepalive = 25;
        }
      ];
    };
  };
}
