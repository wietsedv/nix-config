{ ... }:

{
  programs.seahorse.enable = true;

  security.pam.services = {
    hyprlock.enableGnomeKeyring = true;
  };

  security.polkit.enable = true;

  security.rtkit.enable = true;

  services.getty = {
    autologinOnce = true;
    autologinUser = "wietse";
  };

  services.gnome.gnome-keyring.enable = true;
}
