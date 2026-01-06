{ config, ... }:

{
  services.headscale = {
    enable = true;

    port = 443;
    address = "0.0.0.0";

    settings = {
      server_url = "https://headscale.${config.networking.hostName}.${config.globalDomain}:443";
      tls_letsencrypt_hostname = "headscale.${config.networking.hostName}.${config.globalDomain}";

      dns = {
        base_domain = "tn.${config.globalDomain}";

        nameservers.global = [
          "9.9.9.9"
          "149.112.112.112"
          "2620:fe::fe"
          "2620:fe::9"
        ];

        # TODO move dns here when tailscale gets proper subdomain support
        # https://github.com/tailscale/tailscale/pull/18258
      };
    };
  };

  networking.firewall.allowedTCPPorts = [
    80
    443
    # 50443 # gRPC, for remote CLI
  ];
  # networking.firewall.allowedUDPPorts = [
  #   3478  # STUN, for embedded DERP
  # ];
}
