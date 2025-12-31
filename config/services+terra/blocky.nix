{ config, ... }:

{
  networking.firewall.interfaces."lan0" = {
    allowedTCPPorts = [ config.services.blocky.settings.ports.dns ];
    allowedUDPPorts = [ config.services.blocky.settings.ports.dns ];
  };

  services.blocky = {
    enable = true;

    settings = {
      ports.dns = 5300;

      upstreams = {
        strategy = "strict";
        groups.default = [
          "tcp-tls:dns.quad9.net"
          "https://dns.quad9.net/dns-query"
        ];
      };

      bootstrapDns = [
        {
          upstream = "tcp-tls:dns.quad9.net";
          ips = [
            "9.9.9.9"
            "149.112.112.112"
          ];
        }
        {
          upstream = "https://dns.quad9.net/dns-query";
          ips = [
            "9.9.9.9"
            "149.112.112.112"
          ];
        }
      ];

      caching = {
        minTime = "1h";
        maxTime = "6h";
        prefetching = true;
      };

      blocking = {
        downloadAttempts = 10;
        downloadCooldown = "30s";
        startStrategy = "fast";
        refreshPeriod = "72h";
        clientGroupsBlock.default = [ "block" ];
        blackLists.block = [
          "https://blocklistproject.github.io/Lists/ads.txt"
          "https://blocklistproject.github.io/Lists/crypto.txt"
          "https://blocklistproject.github.io/Lists/malware.txt"
          "https://blocklistproject.github.io/Lists/phishing.txt"
          "https://blocklistproject.github.io/Lists/tracking.txt"
        ];
      };
    };
  };
}
