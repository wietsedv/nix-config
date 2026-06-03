{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    loupe
    nautilus
    papers
  ];

  services.gnome.sushi.enable = true;
}
