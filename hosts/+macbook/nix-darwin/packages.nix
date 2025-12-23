{ ... }:

{
  environment.systemPath = [ "/opt/homebrew/bin" ];

  homebrew = {
    enable = true;
    taps = [
      "homebrew/cask"
      "homebrew/services"
    ];
    casks = [
      "1password"
      "1password-cli"
      {
        name = "alfred";
        greedy = true;
      }
      "freecad"
      "gimp"
      "inkscape"
      "kicad"
      "nextcloud-vfs"
      "notunes"
      "onlyoffice"
      "orbstack"
      "orcaslicer"
      "proton-mail-bridge"
      "tailscale-app"
      "ungoogled-chromium"
      "vlc"
    ];
    onActivation = {
      cleanup = "uninstall";
    };
  };
}
