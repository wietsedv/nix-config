{ pkgs, lib, ... }:

{
  home.packages = with pkgs; [
    google-chrome
    llm-agents.herdr-app
    (lib.warn
      "euro-office-desktopeditors: local workaround active, built with gtk2 = null because nixpkgs marks gtk2 broken (NixOS/nixpkgs#410814) and the package still lists it in buildInputs. Drop this override once NixOS/nixpkgs#582388 reaches our nixpkgs pin (the override then errors with an unexpected argument 'gtk2')."
      (euro-office-desktopeditors.override { gtk2 = null; })
    )
    slack
    vlc
  ];
}
