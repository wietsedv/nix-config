{ osConfig, ... }:

{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;

    settings = {
      "luna" = {
        hostname = "luna.${osConfig.globalDomain}";
      };
    };
  };
}
