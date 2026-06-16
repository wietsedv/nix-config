{ config, pkgs, ... }:

{
  services = {
    nextcloud = {
      enable = true;
      package = pkgs.nextcloud33;
      autoUpdateApps.enable = true;
      hostName = "nextcloud.${config.networking.hostName}.${config.globalDomain}";

      config = {
        adminuser = "wietse";
        adminpassFile = "/var/lib/nextcloud/adminpass";
        dbtype = "pgsql";
      };
      settings = {
        log_type = "file";
        mail_smtpmode = "smtp";
        mail_smtphost = "127.0.0.1";
        mail_smtpport = 1025;
        "overwrite.cli.url" = "https://${config.services.nextcloud.hostName}";
        maintenance_window_start = 1;
        trusted_proxies = [ "127.0.0.1" ];
        overwriteprotocol = "https";
        default_phone_region = "NL";
      };
      phpOptions = {
        "opcache.interned_strings_buffer" = "16";
      }; # prevent dashboard warning

      database.createLocally = true;
      configureRedis = true;
      # notify_push.enable = true;
    };
  };

  custom.web-apps.nextcloud.port = config.services.nginx.defaultHTTPListenPort;
}
