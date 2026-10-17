{ pkgs, ... }:

{
  programs._1password.enable = true;

  programs._1password-gui =
    if pkgs.stdenv.hostPlatform.isLinux then
      {
        enable = true;
        polkitPolicyOwners = [ "wietse" ];
      }
    else
      {
        enable = true;
      };
}
