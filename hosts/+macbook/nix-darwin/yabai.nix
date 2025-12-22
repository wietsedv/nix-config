{ ... }:

{
  services.yabai = {
    enable = true;
    enableScriptingAddition = true;
    extraConfig = ''
      # Window placement
      yabai -m config layout bsp
      yabai -m config split_ratio 0.5
      yabai -m config auto_balance off
      yabai -m config window_topmost on

      # Mouse
      yabai -m config mouse_modifier ctrl
      yabai -m config mouse_action1 move
      yabai -m config mouse_action2 resize
      yabai -m config focus_follows_mouse autofocus

      # Window padding
      yabai -m config top_padding    5
      yabai -m config bottom_padding 10
      yabai -m config left_padding   10
      yabai -m config right_padding  10
      yabai -m config window_gap     10

      # Window mods
      # yabai -m config window_opacity on
      # yabai -m config active_window_opacity 1.0
      # yabai -m config normal_window_opacity 0.9

      # Special rules
      yabai -m rule --add app="^Firefox$" title=" openen$" manage=off
    '';
  };
}
