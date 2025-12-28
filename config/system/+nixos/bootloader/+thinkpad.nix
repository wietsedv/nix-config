{ ... }:

{
  boot.initrd.systemd.enable = true;

  boot.lanzaboote = {
    enable = true;
    configurationLimit = 24;
    pkiBundle = "/var/lib/sbctl";
    autoGenerateKeys.enable = true;
    autoEnrollKeys.enable = true;
  };

  boot.loader = {
    efi.canTouchEfiVariables = true;
  };
}
