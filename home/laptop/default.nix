{ lib, ... }:

{
  imports = builtins.map (name: ./${name}) (
    (lib.mapAttrsToList) (name: _: name) (
      lib.filterAttrs (name: _: name != "default.nix") (builtins.readDir ./.)
    )
  );
}
