{ pkgs, ... }:

let
  python = pkgs.python314;
in
{
  environment.variables = {
    UV_PYTHON = "${python}/bin/python3";
    UV_PYTHON_DOWNLOADS = "never";
  };

  environment.systemPackages = [
    python
    pkgs.uv
  ];

  programs.nix-ld.enable = true;
}
