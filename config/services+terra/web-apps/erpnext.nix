{ config, ... }:

{
  services.erpnext = {
    enable = true;
    siteName = "erpnext.${config.networking.hostName}.${config.globalDomain}";
    adminPasswordFile = "/var/lib/erpnext/admin-password";
    webPort = 8002;
  };

  services.nginx.virtualHosts."${config.services.erpnext.nginx.virtualHost}".listen = [
    {
      addr = "127.0.0.1";
      port = config.custom.web-apps.erpnext.port;
    }
  ];

  custom.web-apps.erpnext.port = 8080;
}
