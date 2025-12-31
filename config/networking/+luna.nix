{ ... }:

{
  networking.nat = {
    enable = true;
    externalInterface = "ens3";
  };

  networking.useDHCP = false;

  systemd.network = {
    enable = true;

    networks."10-ens3" = {
      matchConfig.Name = "ens3";
      DHCP = "yes";
    };
  };
}
