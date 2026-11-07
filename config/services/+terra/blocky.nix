{ config, ... }:

{
  networking.nftables.tables."blocky" = {
    family = "inet";
    content = ''
      chain pre {
        type nat hook prerouting priority dstnat;
        iifname "lan0" tcp dport 53 redirect to :${toString config.services.blocky.settings.ports.dns}
        iifname "lan0" udp dport 53 redirect to :${toString config.services.blocky.settings.ports.dns}
      }
    '';
  };

  networking.firewall.interfaces."lan0" = {
    allowedTCPPorts = [ config.services.blocky.settings.ports.dns ];
    allowedUDPPorts = [ config.services.blocky.settings.ports.dns ];
  };

  services.blocky = {
    enable = true;

    settings = {
      ports.dns = 5300;

      customDNS.mapping = {
        "${config.networking.hostName}.${config.globalDomain}" = "192.168.0.1";
      };

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
        loading = {
          strategy = "fast";
          refreshPeriod = "72h";
          downloads = {
            attempts = 10;
            cooldown = "30s";
          };
        };
        clientGroupsBlock.default = [ "hagezi" ];
        denylists.hagezi = [
          "https://raw.githubusercontent.com/hagezi/dns-blocklists/main/wildcard/pro.txt"
          "https://raw.githubusercontent.com/hagezi/dns-blocklists/main/wildcard/tif.txt"
        ];
      };
    };
  };
}
