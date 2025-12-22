{ pkgs, ... }:

{
  # for home-manager programs.zsh.enableCompletion
  environment.pathsToLink = [ "/share/zsh" ];

  programs.zsh = {
    enable = true;
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;
  };

  programs.starship = {
    enable = true;
    # settings = {
    #   # nix_shell = {
    #   #   heuristic = true;
    #   # };
    # };
  };

  users.defaultUserShell = pkgs.zsh;
}
