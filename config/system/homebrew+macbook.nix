{ ... }:

{
  environment.systemPath = [ "/opt/homebrew/bin" ];

  homebrew = {
    enable = true;
    taps = [
      "homebrew/cask"
      "homebrew/services"
    ];
    onActivation = {
      cleanup = "uninstall";
    };
  };
}
