{ ... }:

{
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  programs.dconf.enable = true;

  services.keyd = {
    enable = true;
    keyboards.default.settings.main = {
      capslock = "f14";
    };
  };
}
