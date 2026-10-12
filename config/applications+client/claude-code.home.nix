{ config, ... }:

{
  programs.claude-code = {
    enable = true;
    enableMcpIntegration = true;
    skills.herdr = "${config.programs.herdr.package}/share/skills/herdr/herdr";
  };
}
