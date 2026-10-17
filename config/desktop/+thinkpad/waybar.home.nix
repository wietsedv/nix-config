{ ... }:

{
  services.network-manager-applet.enable = true;

  programs.waybar = {
    enable = true;
    systemd.enable = true;

    # TODO gtk-font-name?

    style = ''
      * {
        font-family: inherit;
        font-feature-settings: 'tnum';
        font-size: 13px;
        font-weight: 400;
        min-height: 0;
      }

      window#waybar {
        background: alpha(@theme_base_color, 0.6);
        border-bottom: none;
        color: @theme_text_color;
      }

      window#waybar > box {
        padding: 0 12px;
      }

      label.module {
        padding: 0 12px;
      }

      #battery.full {
        color: green;
      }
      #battery.charging {
        color: orange;
      }
    '';

    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 24;
        spacing = 6;
        modules-left = [
          "hyprland/workspaces"
        ];
        modules-center = [
          "hyprland/window"
        ];
        modules-right = [
          "tray"
          "wireplumber"
          "bluetooth"
          "network"
          "battery"
          "clock"
        ];

        "tray" = {
          spacing = 12;
          icons = {
            # blueman = "bluetooth";
          };
        };

        "hyprland/workspaces" = {
          "format" = "{icon}";
          "on-click" = "activate";
          "sort-by-number" = true;
        };

        "hyprland/window" = {
          # icon = true;
        };

        "battery" = {
          format = "{icon}   {capacity}%";
          format-icons = [
            ""
            ""
            ""
            ""
            ""
          ];
          tooltip-format = "{timeTo} ({power}W)";
        };

        "power-profiles-daemon" = {
          format-icons = [ ];
        };

        "network" = {
          "format" = "{ifname}";
          "format-wifi" = "   {essid}";
        };

        "bluetooth" = {
          on-click = "walker -m bluetooth";
        };

        "clock" = {
          format = "{:%a %d %b  %H:%M}";
          on-click = "swaync-client -t -sw";
          tooltip = false;
        };
      };
    };
  };
}
