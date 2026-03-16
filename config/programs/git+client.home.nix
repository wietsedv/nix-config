{ ... }:

{
  programs.git = {
    enable = true;
    signing = {
      format = "ssh";
      key = "~/.ssh/id_ed25519.pub";
      signByDefault = true;
    };
    settings = {
      user = {
        name = "Wietse de Vries";
        email = "wietsedv@proton.me";
      };
      push = {
        autoSetupRemote = true;
      };
      init.defaultBranch = "main";
      alias = {
        wt = "worktree";
        feat = "!f() { git worktree add feature-$1 -b feature/$1 origin/develop; }; f";
      };
    };
    ignores = [
      ".devenv*"
      ".direnv"

      "devenv.nix"
      "devenv.yaml"
      "devenv.lock"

      "devenv.local.nix"
      "devenv.local.yaml"
    ];
  };
}
