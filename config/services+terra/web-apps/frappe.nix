{ config, ... }:

{
  services.frappe = {
    enable = true;

    sites = {
      "erpnext.${config.networking.hostName}.${config.globalDomain}" = {
        apps = [ "erpnext" ];
        adminPasswordFile = "/var/lib/frappe/admin-password";
      };
    };
  };

  custom.web-apps.erpnext.port = config.services.nginx.defaultHTTPListenPort;
}
