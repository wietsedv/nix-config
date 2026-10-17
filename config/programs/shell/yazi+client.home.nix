{ pkgs, ... }:

{
  programs.yazi = {
    enable = true;
    shellWrapperName = "y";
    plugins = {
      starship = pkgs.yaziPlugins.starship;
    };
    settings = {
      mgr = {
        linemode = "mtime";
      };
      opener = {
        code-workspace = [
          {
            run = ''code "$1"'';
            desc = "code (workspace)";
          }
        ];
        code-files = [
          {
            run = ''code . -g "$@"'';
            desc = "code";
          }
        ];
        nano = [
          {
            run = ''nano "$@"'';
            desc = "nano";
            block = true;
          }
        ];
      };
      open.rules = [
        {
          mime = "inode/directory";
          use = "code-workspace";
        }
        {
          name = "*";
          use = "nano";
        }
        {
          name = "*";
          use = "code-files";
        }
      ];
    };
    initLua = ''
      require("starship"):setup()
    '';
  };
}
