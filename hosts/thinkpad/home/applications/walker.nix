{ inputs, ... }:

# TODO https://github.com/firecat53/networkmanager-dmenu

{
  imports = [
    inputs.walker.homeManagerModules.default
  ];

  wayland.windowManager.hyprland.settings = {
    bind = [ ", code:192, exec, nc -U /run/user/1000/walker/walker.sock" ];
  };

  programs.walker = {
    enable = true;
    runAsService = true;

    # https://github.com/abenz1267/walker/blob/master/resources/config.toml
    config = {
      placeholders = {
        "default" = {
          input = "Zoeken";
          list = "Geen resultaten";
        };
      };
      providers = {
        empty = [ "desktopapplications" ];
        "default" = [
          "desktopapplications"
          "calc"
        ];
      };
    };
  };
}
