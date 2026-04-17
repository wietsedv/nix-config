{ pkgs, ... }:

{
  gtk = {
    enable = true;
    gtk3.extraConfig = {
      gtk-theme-name = "adw-gtk3";
    };
    gtk4.theme = null;
  };

  home.pointerCursor = {
    enable = true;
    gtk.enable = true;
    hyprcursor.enable = true;
    name = "Adwaita";
    package = pkgs.adwaita-icon-theme;
    size = 24;
  };

  home.packages = [
    pkgs.adw-gtk3
    (pkgs.writeShellScriptBin "theme-toggle" ''
      COLOR_SCHEME_KEY=/org/gnome/desktop/interface/color-scheme
      if [ $(dconf read $COLOR_SCHEME_KEY) = "'prefer-dark'" ]; then
        COLOR_SCHEME="'prefer-light'"
      else
        COLOR_SCHEME="'prefer-dark'"
      fi
      dconf write $COLOR_SCHEME_KEY "$COLOR_SCHEME"
    '')
  ];
}
