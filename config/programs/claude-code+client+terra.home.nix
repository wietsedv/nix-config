{ config, pkgs, ... }:

{
  programs.claude-code = {
    enable = true;
    package = pkgs.llm-agents.claude-code.override {
      disableTelemetry = true;
    };
    enableMcpIntegration = true;
    skills.herdr = "${config.programs.herdr.package}/share/skills/herdr/herdr";
  };
}
