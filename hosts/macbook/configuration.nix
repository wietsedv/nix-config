{ pkgs, ... }:

{
  imports = [
    ./nix-darwin/homebrew.nix
    ./nix-darwin/skhd.nix
    ./nix-darwin/yabai.nix
  ];

  environment = {
    pathsToLink = [ "/share/zsh" ];
    systemPackages = with pkgs; [
      biome
      bun
      cmake
      ffmpeg
      gh
      git
      git-lfs
      go
      htop
      jq
      nano
      nil
      nmap
      nodejs_22
      ruby
      sox
      tlrc
      unar
      watchman
      wget
      zulu17
      (python3.withPackages (
        ps: with ps; [
          numpy
          requests
        ]
      ))
    ];
  };

  fonts.packages = [ pkgs.nerd-fonts.meslo-lg ];

  networking.hostName = "macbook";
  networking.computerName = "macbook";
  networking.knownNetworkServices = [
    "Wi-Fi"
  ];
  networking.dns = [
    "1.1.1.1"
    "1.0.0.1"
  ];

  nix = {
    enable = true;
    channel.enable = false;
    optimise.automatic = true;
    settings = {
      trusted-users = [
        "root"
        "wietse"
      ];
    };
  };

  nixpkgs.config.allowUnfree = true;

  nixpkgs.hostPlatform = "aarch64-darwin";

  programs.zsh.enable = true;

  system.primaryUser = "wietse";

  system.stateVersion = 6;

  users.users.wietse.home = "/Users/wietse";
}
