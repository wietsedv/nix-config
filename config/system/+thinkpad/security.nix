{ pkgs, ... }:

{
  programs.seahorse.enable = true;

  security.pam.services = {
    gdm.enableGnomeKeyring = true;
    hyprlock.enableGnomeKeyring = true;
    sudo.fprintAuth = false;
  };

  security.polkit.enable = true;

  security.rtkit.enable = true;

  services.clamav = {
    daemon.enable = true;
    updater.enable = true;
    scanner = {
      enable = true;
      scanDirectories = [ "/home/wietse/Downloads" ];
    };
  };

  services.fprintd = {
    enable = true;
    tod = {
      enable = true;
      driver = pkgs.libfprint-2-tod1-goodix;
    };
  };

  services.gnome.gnome-keyring.enable = true;
}
