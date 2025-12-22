{ pkgs, ... }:

{
  environment = {
    systemPackages = with pkgs; [
      biome
      bun
      cmake
      ffmpeg
      gh
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
}
