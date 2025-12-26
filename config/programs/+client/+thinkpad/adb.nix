{ ... }:

{
  programs.adb.enable = true;

  users.users.wietse.extraGroups = [ "adbusers" ];
}
