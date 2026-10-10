{ ... }:

{
  # Copy app bundles instead of symlinking them into the Nix store, so
  # Spotlight and Alfred index them
  targets.darwin = {
    linkApps.enable = false;
    copyApps.enable = true;
  };
}
