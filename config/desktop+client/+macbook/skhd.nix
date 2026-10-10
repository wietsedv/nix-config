{ pkgs, ... }:

let
  # Reuse the running Ghostty instance; launching the binary cold-starts a new process each time.
  # Spawning from the front window's terminal inherits its working directory.
  ghosttyNewWindow = pkgs.writeText "ghostty-new-window.applescript" ''
    if application id "com.mitchellh.ghostty" is running then
      tell application id "com.mitchellh.ghostty"
        if (count of windows) > 0 then
          perform action "new_window" on focused terminal of selected tab of front window
        else
          new window
        end if
      end tell
    end if
    tell application id "com.mitchellh.ghostty" to activate
  '';
in
{
  services.skhd = {
    enable = true;
    skhdConfig = ''
      # Commands
      cmd - return : osascript ${ghosttyNewWindow}
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
