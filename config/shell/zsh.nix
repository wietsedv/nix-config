{ pkgs, ... }:

{
  programs.zsh =
    if pkgs.stdenv.hostPlatform.isLinux then
      {
        enable = true;
        enableCompletion = true;
        autosuggestions.enable = true;
        syntaxHighlighting.enable = true;
      }
    else
      {
        enable = true;
        enableCompletion = true;
        enableAutosuggestions = true;
        enableSyntaxHighlighting = true;
      };

  users = if pkgs.stdenv.hostPlatform.isLinux then { defaultUserShell = pkgs.zsh; } else { };
}
