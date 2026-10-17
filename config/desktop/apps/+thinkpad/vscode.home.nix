{ ... }:

{
  programs.vscode = {
    enable = true;
    profiles.default = {
      enableMcpIntegration = true;
    };
  };
}
