{ ... }:

# TODO https://github.com/firecat53/networkmanager-dmenu

{
  programs.walker = {
    enable = true;
    runAsService = true;

    # https://github.com/abenz1267/walker/blob/master/resources/config.toml
    config = {
      placeholders = {
        "default" = {
          input = "Zoeken";
          list = "Geen resultaten";
        };
      };
      providers = {
        empty = [ "desktopapplications" ];
        "default" = [
          "desktopapplications"
          "calc"
        ];
      };
    };
  };
}
