{ ... }:

{
  boot.loader = {
    grub = {
      efiSupport = true;
      efiInstallAsRemovable = true;
      configurationLimit = 5;
    };
  };
}
