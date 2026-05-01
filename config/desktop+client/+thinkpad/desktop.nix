{ ... }:

{
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  i18n = {
    defaultLocale = "nl_NL.UTF-8";
    extraLocales = [ "en_US.UTF-8/UTF-8" ];
  };

  programs.dconf.enable = true;

  services.displayManager.gdm.enable = true;

  services.keyd = {
    enable = true;
    keyboards.default.settings.main = {
      capslock = "f14";
    };
  };
}
