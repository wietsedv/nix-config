{ ... }:

{
  nix = {
    channel.enable = false;
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      # trusted-users = [ "@wheel" ];
    };
  };

  nixpkgs.config.allowUnfree = true;

  time.timeZone = "Europe/Amsterdam";
}
