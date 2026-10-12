{ pkgs, ... }:

{
  services.podman.enable = true;

  home.packages = [
    (pkgs.writeShellScriptBin "docker" ''exec podman "$@"'')
  ];
}
