{ lib, pkgs, ... }:

{
  imports = builtins.map (name: ./${name}) (
    (lib.mapAttrsToList) (name: _: name) (
      lib.filterAttrs (name: _: name != "default.nix") (builtins.readDir ./.)
    )
  );

  home.packages = with pkgs; [
    nwg-displays
    brightnessctl
    htop
    tldr
    gnome-font-viewer
    gnome-system-monitor
    nautilus
    nodejs_24
    planify
    resources
    slack
    thunderbird
    ungoogled-chromium
    azure-cli
    vlc
    gcc
    gnumake
    libreoffice
    openssh
    devenv
    shared-mime-info
    (python3.withPackages (ps: [
      ps.numpy
      ps.numba
      ps.pandas
      ps.openpyxl
      ps.scipy
    ]))
    nil
  ];

  programs.firefox = {
    enable = true;
    # package = pkgs.firefox-bin;
  };

  programs.vscode.enable = true;

  programs.zed-editor = {
    enable = true;
    extraPackages = with pkgs; [
      nixd
      nixfmt-rfc-style
    ];
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    history = {
      append = true;
      size = 10000;
    };
    historySubstringSearch.enable = true;
    syntaxHighlighting.enable = true;
  };

  # programs.ssh = {
  #   enable = true;
  #   enableDefaultConfig = false;
  #   matchBlocks."*" = {
  #     identityAgent = "~/.1password/agent.sock";
  #   };
  # };
}
