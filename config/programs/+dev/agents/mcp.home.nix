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
        env = {
          PLAYWRIGHT_BROWSERS_PATH = "${pkgs.playwright-driver.browsers}";
          PLAYWRIGHT_SKIP_BROWSER_DOWNLOAD = "1";
        };
      };
    };
  };
}
