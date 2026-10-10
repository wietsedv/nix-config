{
  config,
  lib,
  pkgs,
  ...
}:

let
  zed = config.programs.zed-editor.package;
  copiedApp = "${config.home.homeDirectory}/${config.targets.darwin.copyApps.directory}/Zed.app";
in
{
  programs.zed-editor = {
    enable = true;
  };

  # With copyApps, the running Zed.app lives outside the store, so the store
  # CLI waits forever on a bundle that never answers. Point it at the copy.
  home.packages = lib.mkIf (pkgs.stdenv.hostPlatform.isDarwin && config.targets.darwin.copyApps.enable) [
    (lib.hiPrio (
      pkgs.writeShellScriptBin "zeditor" ''
        exec ${zed}/bin/zeditor --zed "${copiedApp}" "$@"
      ''
    ))
  ];
}
