{ config, ... }:

{
  sops.secrets.global_domain = { };

  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;
    historySubstringSearch.enable = true;
    shellAliases = {
      "lab" = "ssh homelab";
      "bak" = "ssh backup";
      "vps" = "ssh vps.$(cat ${config.sops.secrets.global_domain.path})";
      "ks" = "TERM=xterm-256color ssh ks";
      "gh" = "TERM=xterm-256color ssh gh";
      "col" = "TERM=xterm-256color ssh col";
    };
  };
}
