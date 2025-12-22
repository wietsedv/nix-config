{ ... }:

{
  environment.systemPath = [ "/opt/homebrew/bin" ];

  homebrew = {
    enable = true;
    taps = [
      "homebrew/cask"
      "homebrew/services"
    ];
    brews = [
      "mas"
    ];
    casks = [
      "1password"
      "1password-cli"
      "alacritty"
      {
        name = "alfred";
        greedy = true;
      }
      # "android-studio"
      "element"
      "firefox"
      "freecad"
      "gimp"
      "inkscape"
      "karabiner-elements"
      "kicad"
      "nextcloud-vfs"
      "notunes"
      # "nrfutil"
      # "obsidian"
      "onlyoffice"
      "orbstack"
      "orcaslicer"
      "proton-mail-bridge"
      # "steam"
      "tailscale-app"
      "thunderbird"
      "ungoogled-chromium"
      "visual-studio-code"
      "vlc"
      "zed"
    ];
    masApps = {
      "reMarkable desktop" = 1276493162;
    };
    onActivation = {
      # autoUpdate = true;
      cleanup = "uninstall";
      # upgrade = true;
    };
  };
}
