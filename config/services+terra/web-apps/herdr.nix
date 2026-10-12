{ ... }:

{
  custom.web-apps.herdr.port = 7317;

  services.traefik.dynamicConfigOptions.http = {
    middlewares.herdr-headers.headers.customRequestHeaders = {
      X-Forwarded-Proto = "https";
      Tailscale-User-Login = "";
    };
    routers.herdr.middlewares = [ "herdr-headers" ];
  };
}
