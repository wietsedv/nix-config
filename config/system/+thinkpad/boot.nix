{ pkgs, ... }:

{
  boot = {
    # enable systemd in initrd for luks decryption (?)
    initrd.systemd.enable = true;

    kernelPackages = pkgs.linuxPackages_latest;
    # kernelParams = [ "acpi_backlight=native" ];
    # extraModprobeConfig = "options thinkpad_acpi fan_control=0";

    # blacklistedKernelModules = [ "thinkpad_acpi" ];

    # kernelModules = [ "thinkpad_acpi" ];

    lanzaboote = {
      enable = true;
      configurationLimit = 24;
      pkiBundle = "/var/lib/sbctl";
      autoGenerateKeys.enable = true;
      autoEnrollKeys.enable = true;
    };

    loader = {
      # systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };
}
