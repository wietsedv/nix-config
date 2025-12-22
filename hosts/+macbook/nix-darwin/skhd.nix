{ ... }:

{
  services.skhd = {
    enable = true;
    skhdConfig = ''
      # Commands
      cmd - return : /etc/profiles/per-user/wietse/bin/ghostty
      shift + cmd - o : /Applications/Firefox.app/Contents/MacOS/firefox
      alt + cmd - return : open ~

      # Focus window
      alt - a : yabai -m window --focus west
      alt - s : yabai -m window --focus south
      alt - w : yabai -m window --focus north
      alt - d : yabai -m window --focus east

      # Move window
      shift + alt - a : yabai -m window --warp west
      shift + alt - s : yabai -m window --warp south
      shift + alt - w : yabai -m window --warp north
      shift + alt - d : yabai -m window --warp east

      # Resize window
      cmd + alt - s : yabai -m window --resize top:0:120; yabai -m window --resize bottom:0:120
      cmd + alt - w : yabai -m window --resize top:0:-120; yabai -m window --resize bottom:0:-120
      cmd + alt - q : yabai -m window --resize abs:1000:600

      cmd + alt - a : yabai -m window --resize left:-120:0 || yabai -m window --resize right:-120:0
      cmd + alt - d : yabai -m window --resize left:120:0 || yabai -m window --resize right:120:0

      # Center/fullscreen
      alt + cmd - f : yabai -m window --toggle zoom-fullscreen
      alt + cmd - g : yabai -m window --toggle zoom-parent
      alt + cmd - c : yabai -m window --toggle float; yabai -m window --grid 8:8:1:1:6:6
    '';
  };
}
