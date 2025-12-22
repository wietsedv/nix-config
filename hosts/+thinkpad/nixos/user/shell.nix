{ pkgs, ... }:

{
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
