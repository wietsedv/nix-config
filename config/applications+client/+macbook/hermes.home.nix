{ osConfig, ... }:

{
  # Point Hermes Desktop at the backend on terra instead of a local one.
  launchd.agents.hermes-desktop-remote = {
    enable = true;
    config = {
      ProgramArguments = [
        "/bin/launchctl"
        "setenv"
        "HERMES_DESKTOP_REMOTE_URL"
        "https://hermes.terra.${osConfig.globalDomain}"
      ];
      RunAtLoad = true;
    };
  };
}
