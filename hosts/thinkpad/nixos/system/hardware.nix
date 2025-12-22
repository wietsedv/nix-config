{ pkgs, ... }:

{
  hardware.bluetooth.enable = true;

  hardware.enableAllFirmware = true;

  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver
      libvdpau-va-gl
      vpl-gpu-rt
    ];
  };

  services.fwupd.enable = true;

  services.blueman.enable = true;

  swapDevices = [
    {
      device = "/swap/swapfile";
      size = 64 * 1024;
    }
  ];
}
