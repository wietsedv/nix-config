{ pkgs, ... }:

{
  home = {
    sessionVariables = {
      XDG_CONFIG_HOME = "/Users/wietse/.config";
    };
    packages = with pkgs; [
      sops
    ];
  };

  sops = {
    defaultSopsFile = ../../../secrets/secrets.yaml;
    age.keyFile = "/Users/wietse/.config/sops/age/keys.txt";
  };
}
