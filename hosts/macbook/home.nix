{ pkgs, ... }:

{
  imports = [
    ./home/yazi.nix
    ./home/zsh.nix
  ];

  home = {
    sessionVariables = {
      XDG_CONFIG_HOME = "/Users/wietse/.config";
    };
    packages = with pkgs; [
      sops
    ];
  };

  sops = {
    defaultSopsFile = ../../secrets/secrets.yaml;
    age.keyFile = "/Users/wietse/.config/sops/age/keys.txt";
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    enableZshIntegration = true;
  };

  programs.starship = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };

  home.stateVersion = "23.05";
}
