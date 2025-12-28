{ ... }:

{
  nixpkgs.hostPlatform = "aarch64-darwin";

  users.users.wietse = {
    home = "/Users/wietse";
  };

  system.primaryUser = "wietse";

  system.stateVersion = 6;

  time.timeZone = "Europe/Amsterdam";
}
