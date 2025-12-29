{ ... }:

{
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

  networking.nameservers = [ "1.1.1.1" ];

  # disable legacy option
  networking.useDHCP = false;

  networking.nat = {
    enable = true;
    externalInterface = "wan0";
    internalInterfaces = [ "lan0" ];
  };

  # Multicast DNS
  services.resolved = {
    llmnr = "false";
    extraConfig = ''
      MulticastDNS=yes
    '';
  };
  networking.firewall.interfaces."lan0".allowedUDPPorts = [ 5353 ];
}
