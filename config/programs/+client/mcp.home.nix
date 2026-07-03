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
    };
  };
}
