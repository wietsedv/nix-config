lib:

let
  readDir =
    path:
    if builtins.pathExists path then
      (lib.mapAttrsToList (mapPath path) (builtins.readDir path))
    else
      [ ];

  mapPath =
    path: name: type:
    if type == "directory" then readDir (path + /${name}) else (path + /${name});
in

subdirs: path:
builtins.filter (lib.hasSuffix ".nix") (
  lib.lists.flatten (map (name: readDir (path + /${name})) subdirs)
)
