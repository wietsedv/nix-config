{ ... }:

{
  networking.networkmanager.enable = true;

  # TODO avahi?
  #
  # services.avahi = {
  #   enable = true;
  #   # nssmdns4 = true;
  # };

  services.resolved = {
    enable = true;
    # dnssec = "true";
    # dnsovertls = "true";
  };

  # open port 5353 for mdns?

  services.tailscale = {
    enable = true;
    useRoutingFeatures = "client";
    openFirewall = true;
  };
}
