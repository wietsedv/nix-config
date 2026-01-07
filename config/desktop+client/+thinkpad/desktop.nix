{ ... }:

{
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  # TODO vulkan renderer is glitchy door bug in mesa-25.3.0
  # https://github.com/NixOS/nixpkgs/issues/463220
  # environment.sessionVariables.GSK_RENDERER = "gl";

  # environment.sessionVariables.XDG_SESSION_TYPE = "wayland";
  # environment.sessionVariables.XDG_SESSION_DESKTOP = "Hyprland";

  i18n = {
    defaultLocale = "nl_NL.UTF-8";
    extraLocales = [ "en_US.UTF-8/UTF-8" ];
  };

  programs.dconf.enable = true;

  # programs.dconf.profiles.gdm.databases = [{
  #   settings."org/gnome/login-screen" = {
  #     disable-user-list = true;
  #   };
  # }];

  services.dbus.implementation = "broker";

  services.displayManager.gdm.enable = true;

  services.keyd = {
    enable = true;
    keyboards.default.settings.main = {
      capslock = "f14";
    };
  };

  # xdg.portal = {
  #   config = {
  #     # example with hyprland
  #     hyprland.preferred = [ "hyprland" "gtk" ];
  #   };
  # };
}
