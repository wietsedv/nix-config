{ pkgs, ... }:

{
  programs.claude-code = {
    enable = true;
    package = pkgs.llm-agents.claude-code.override {
      disableTelemetry = true;
    };
    enableMcpIntegration = true;
    skills = {
      herdr = ./skills/herdr;
    };
  };
}
