{ config, pkgs, ... }:

{
  services.calibre-web = {
    enable = true;
    package = (
      pkgs.calibre-web.overridePythonAttrs (prev: {
        dependencies = prev.dependencies ++ prev.optional-dependencies.kobo;
      })
    );
    group = "media";
    listen.ip = "127.0.0.1";
    options = {
      calibreLibrary = "/data/media/ebooks";
      enableBookConversion = true;
      enableKepubify = true;
      enableBookUploading = true;
    };
  };

  systemd.services.calibre-web.serviceConfig.UMask = "002";

  services.traefik.dynamicConfigOptions.http = {
    routers.calibre-web = {
      rule = "Host(`calibre-web.${config.networking.hostName}.${config.globalDomain}`)";
      service = "calibre-web";
    };
    services.calibre-web.loadBalancer.servers = [
      { url = "http://127.0.0.1:${toString config.services.calibre-web.listen.port}"; }
    ];
  };
}
