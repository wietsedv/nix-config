{ pkgs, ... }:

{
  environment.variables = {
    UV_PYTHON = "${pkgs.python3}/bin/python3";
    UV_PYTHON_DOWNLOADS = "never";
  };

  environment.systemPackages = with pkgs; [
    python3
    uv
  ];
}
