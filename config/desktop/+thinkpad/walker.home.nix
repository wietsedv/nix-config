{ lib, pkgs, ... }:

{
  programs.walker = {
    enable = true;
    package = pkgs.walker;
    runAsService = true;

    # https://github.com/abenz1267/walker/blob/master/resources/config.toml
    config = {
      placeholders = {
        default = {
          input = "Zoeken";
          list = "Geen resultaten";
        };
      };
      providers = {
        empty = [
          "menus"
          "desktopapplications"
        ];
        default = [
          "menus"
          "desktopapplications"
          "calc"
        ];
      };
    };
  };

  programs.elephant = {
    package = pkgs.elephant;
    provider.menus.lua = {
      "vscode-workspaces" =
        lib.generators.toLua
          {
            multiline = true;
            asBindings = true;
          }
          {
            Name = "vscode-workspaces";
            NamePretty = "Visual Studio Code Workspaces";
            Description = "Visual Studio Code Workspaces";
            Icon = "applications-other";
            Action = "code %VALUE%";
            SearchName = true;
            Cache = true;
            GetEntries = lib.generators.mkLuaInline ''
              function()
                  local entries = {}
                  local handle = io.popen("find '/home/wietse/Projecten' -maxdepth 2 -type f -name '*.code-workspace' 2>/dev/null")
                  if handle then
                      for line in handle:lines() do
                          local filename = line:match("([^/]+)$")
                          if filename then
                              table.insert(entries, {
                                  Text = filename,
                                  Subtext = "Visual Studio Code Workspace",
                                  Value = line,
                              })
                          end
                      end
                      handle:close()
                  end
                  return entries
              end
            '';
          };
    };
  };
}
