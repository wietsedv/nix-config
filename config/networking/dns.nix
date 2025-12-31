{ pkgs, ... }:

let
  nameservers = [
    "9.9.9.9"
    "149.112.112.112"
    "2620:fe::fe"
    "2620:fe::9"
  ];
in
{
  networking =
    if pkgs.stdenv.isLinux then
      {
        inherit nameservers;
      }
    else
      {
        dns = nameservers;
        knownNetworkServices = [ "Wi-Fi" ];
      };
}
