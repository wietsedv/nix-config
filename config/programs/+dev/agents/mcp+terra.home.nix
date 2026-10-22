{ lib, ... }:

{
  programs.mcp.servers."playwright-nix".args = lib.mkAfter [ "--headless" ];
}
