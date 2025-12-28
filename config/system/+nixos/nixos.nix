{ pkgs, ... }:

{
  boot.kernelPackages = pkgs.linuxPackages_latest;

  boot.kernel.sysctl = {
    "net.ipv4.tcp_congestion_control" = "bbr";
  };

  users.users.wietse = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
  };

  services.fwupd.enable = true;

  system.stateVersion = "25.05";

  time.timeZone = "Europe/Amsterdam";
}
