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
