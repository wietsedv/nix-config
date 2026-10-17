{ pkgs, ... }:

{
  programs.mcp = {
    enable = true;
    servers = {
      "nixos" = {
        type = "stdio";
        command = "${pkgs.mcp-nixos}/bin/mcp-nixos";
        args = [ ];
      };
      "playwright-nix" = {
        type = "stdio";
        command = "${pkgs.playwright-test}/bin/playwright";
        args = [
          "mcp"
          "--browser=chromium"
        ];
      };
    };
  };
}
