{ pkgs, ... }:

{
  programs.zsh =
    if pkgs.stdenv.isLinux then
      {
        enable = true;
        autosuggestions.enable = true;
        syntaxHighlighting.enable = true;
      }
    else
      {
        enable = true;
        enableAutosuggestions = true;
        enableSyntaxHighlighting = true;
      };

  users = if pkgs.stdenv.isLinux then { defaultUserShell = pkgs.zsh; } else { };
}
