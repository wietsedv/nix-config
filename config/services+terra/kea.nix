{ config, lib, ... }:

let
  prefix = "192.168.0";
in
{
  networking.firewall.interfaces."lan0".allowedUDPPorts = [ 67 ];

  services.kea.dhcp4 = {
    enable = true;
    settings = {
      interfaces-config = {
        interfaces = config.networking.nat.internalInterfaces;
        dhcp-socket-type = "raw";
        service-sockets-max-retries = 10;
        service-sockets-require-all = true;
      };
      lease-database = {
        type = "memfile";
        persist = true;
        name = "/var/lib/kea/dhcp4.leases";
      };
      valid-lifetime = 28800;

      subnet4 = lib.singleton {
        id = 1;
        subnet = "${prefix}.0/24";
        pools = lib.singleton { pool = "${prefix}.100 - ${prefix}.199"; };
        option-data = [
          {
            name = "routers";
            data = "${prefix}.1";
          }
          {
            name = "domain-name-servers";
            data = "${prefix}.1";
          }
        ];
      };
    };
  };
}
