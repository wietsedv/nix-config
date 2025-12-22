{ pkgs, ... }:

{
  gtk = {
    enable = true;
    gtk3.extraConfig = {
      gtk-theme-name = "adw-gtk3";
    };
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
      if [ $(dconf read /org/gnome/desktop/interface/color-scheme) = "'prefer-dark'" ]; then
        dconf write /org/gnome/desktop/interface/color-scheme "'prefer-light'"
      else
        dconf write /org/gnome/desktop/interface/color-scheme "'prefer-dark'"
      fi
    '')
  ];

  services.hyprpaper = {
    enable = true;
    settings = {
      preload = "/etc/nixos/wallpaper.png";
      wallpaper = ", /etc/nixos/wallpaper.png";
    };
  };
}
