{ ... }:

{
  # nftables instead of iptables
  networking.nftables.enable = true;

  # systemd-resolved instead of resolvconf / avahi
  services.resolved.enable = true;
  services.avahi.enable = false;
}
