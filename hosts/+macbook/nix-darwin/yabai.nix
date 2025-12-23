{ ... }:

{
  services.yabai = {
    enable = true;
    enableScriptingAddition = true;
    config = {
      # Window placement
      layout = "bsp";
      split_ratio = 0.5;
      auto_balance = "off";
      window_topmost = "on";

      # Mouse
      mouse_modifier = "alt";
      mouse_action1 = "move";
      mouse_action2 = "resize";
      focus_follows_mouse = "autofocus";

      # Window padding
      top_padding = 5;
      bottom_padding = 10;
      left_padding = 10;
      right_padding = 10;
      window_gap = 10;
    };
    extraConfig = ''
      yabai -m rule --add app="^Firefox$" title=" openen$" manage=off
    '';
  };
}
