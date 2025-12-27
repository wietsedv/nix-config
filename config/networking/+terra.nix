{ ... }:

{
  networking = {
    # Interfaces
    # TODO rename enp0s31f6 to wan0 via systemd.network.links
    # TODO rename enp2s0 to lan0 via systemd.network.links

    # DNS
    # TODO services.resolved.enable = true;
    # open port 5353 for mDNS? use avahi if mdns does not work
    domain = "local";
    nameservers = [ "192.168.0.1" ];

    # DHCP
    # TODO enable kea here?
    # TODO current state: useDHCP enabled by default, disabled whe networking.interfaces.<name>.ipv4.addresses is set (lan)
    # might be different for systemd-networkd
    # do NOT use the networking.useNetworkd compatibility layer
    # networking.useDHCP should probably be set to false and dhcp should be manually enabled for lan via systemd.network.networks
    # use router advertisements for ipv6? https://wiki.nixos.org/wiki/Systemd/networkd#DHCP/RA

    # LAN
    # TODO replace with systemd-networkd
    # https://wiki.nixos.org/wiki/Systemd/networkd
    # systemd.network.networks
    # TODO fix wireguard
    bridges."lan0".interfaces = [ "enp2s0" ];
    interfaces."lan0".ipv4.addresses = [
      {
        address = "192.168.0.1";
        prefixLength = 16;
      }
    ];

    # NAT
    # TODO networking.nftables.enable = true;
    # TODO fix wireguard
    nat = {
      enable = true;
      externalInterface = "enp0s31f6";
      internalInterfaces = [ "lan0" ];
      # internalIPs = [ "192.168.0.0/16" ]; # test if necessary
    };

    # Firewall
    # TODO is enabled by default. will use nftables backend. move to here
  };
}
