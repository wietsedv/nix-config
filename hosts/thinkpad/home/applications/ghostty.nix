{ ... }:

{
  wayland.windowManager.hyprland.settings.bind = [
    "SUPER, return, exec, ghostty +new-window"
  ];

  programs.ghostty = {
    enable = true;
    systemd.enable = true;
    settings = {
      quit-after-last-window-closed = false;
      font-size = 10;
      theme = "light:Adwaita,dark:Adwaita Dark";
      window-padding-x = 10;
      window-padding-y = 5;
      window-padding-balance = true;
      app-notifications = false;
    };
  };

  programs.yazi = {
    enable = true;
    shellWrapperName = "y";
    # plugins = {
    #   starship = pkgs.yaziPlugins.starship;
    # };
    # initLua = ''
    #   require("starship"):setup()
    # '';
    settings = {
      mgr = {
        linemode = "mtime";
      };
      opener = {
        zeditor = [
          {
            run = ''zeditor "$1"'';
            desc = "Zed";
          }
        ];
      };
      open.rules = [
        {
          mime = "inode/directory";
          use = "zeditor";
        }
      ];
    };
  };
}
