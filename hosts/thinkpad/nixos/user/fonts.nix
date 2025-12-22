{ pkgs, ... }:

{
  fonts = {
    enableDefaultPackages = true;

    packages = with pkgs; [
      inter
      nerd-fonts.adwaita-mono
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
        monospace = [ "AdwaitaMono Nerd Font" ];
        emoji = [ "Noto Color Emoji" ];
      };
    };
  };
}
