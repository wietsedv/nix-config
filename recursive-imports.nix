lib: path: suffix: targets:

let
  # directory/file basename must include one of the targets if any target is specified with +
  validateBasename =
    name:
    !lib.hasInfix "+" name
    || builtins.any (target: builtins.elem target targets) (builtins.tail (lib.splitString "+" name));

  # file must have matching suffix. e.g. ".home.nix" if suffix == "home" or just ".nix" if suffix == ""
  extension = if suffix == "" then ".nix" else ".${suffix}.nix";
  validateExtension =
    name: lib.hasSuffix extension name && !lib.hasInfix "." (lib.removeSuffix extension name);
  validateFilename =
    name: validateExtension name && validateBasename (lib.removeSuffix extension name);

  # read and filter the specified directory as set
  validate = name: type: if type == "directory" then validateBasename name else validateFilename name;
  readAndFilterDir = path: lib.filterAttrs validate (builtins.readDir path);

  # recursively read directory and map to list
  readDirRecursive =
    path:
    lib.mapAttrsToList (
      name: type: if type == "directory" then readDirRecursive (path + /${name}) else path + /${name}
    ) (readAndFilterDir path);
in

lib.flatten (readDirRecursive path)
