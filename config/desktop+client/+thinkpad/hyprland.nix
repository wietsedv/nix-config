{ ... }:

{
  programs.hyprland.enable = true;

  programs.uwsm.enable = true;

  environment.loginShellInit = ''
    if uwsm check may-start; then
      exec uwsm start hyprland.desktop
    fi
  '';
}
