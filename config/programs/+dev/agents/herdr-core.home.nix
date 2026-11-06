{ pkgs, ... }:

{
  home.packages = [
    pkgs.llm-agents.herdr-core
  ];

  home.file.".local/bin/herdr-core".source = "${pkgs.llm-agents.herdr-core}/bin/herdr-core";
}
