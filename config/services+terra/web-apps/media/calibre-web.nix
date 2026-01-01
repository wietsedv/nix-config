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

  custom.web-apps.calibre-web.port = config.services.calibre-web.listen.port;
}
