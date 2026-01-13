{ pkgs, ... }:

{
  fonts = {
    enableDefaultPackages = true;

    packages = with pkgs; [
      inter
      nerd-fonts.meslo-lg
      noto-fonts-color-emoji
    ];

    fontconfig = {
      enable = true;
      includeUserConf = false;
      subpixel.rgba = "rgb";
      hinting = {
        enable = true;
        autohint = false;
        style = "none";
      };
      defaultFonts = {
        serif = [ "Inter" ];
        sansSerif = [ "Inter" ];
        monospace = [ "MesloLGS Nerd Font Mono" ];
        emoji = [ "Noto Color Emoji" ];
      };
    };
  };
}
