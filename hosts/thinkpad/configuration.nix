{ ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./nixos/system
    ./nixos/user
  ];

  networking.hostName = "thinkpad";

  networking.networkmanager.enable = true;

  services.resolved = {
    enable = true;
    # dnssec = "true";
    # dnsovertls = "true";
  };

  # open port 5353 for mdns?

  services.tailscale = {
    enable = true;
    useRoutingFeatures = "client";
  };

  # TODO avahi?
  #
  # services.avahi = {
  #   enable = true;
  #   # nssmdns4 = true;
  # };

  nix = {
    channel.enable = false;
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      trusted-users = [
        "root"
        "wietse"
      ];
    };
  };

  nixpkgs.config.allowUnfree = true;

  programs.nix-ld.enable = true;

  time.timeZone = "Europe/Amsterdam";

  users.users.wietse = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
  };

  system.stateVersion = "25.05";
}
