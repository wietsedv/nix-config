{ osConfig, ... }:

{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;

    matchBlocks = {
      "luna" = {
        hostname = "luna.${osConfig.globalDomain}";
      };
    };
  };
}
