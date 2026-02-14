{ config, lib, ... }:

let
  enabledWebApps = lib.filterAttrs (n: v: v.enable && v.port != null) config.personal.web-apps;

  domain = "${config.networking.hostName}.${config.globalDomain}";
in
{
  options.custom.web-apps = lib.mkOption {
    type = lib.types.attrsOf (
      lib.types.submodule (
        { name, ... }:
        {
          options.port = lib.mkOption {
            type = lib.types.port;
          };
        }
      )
    );
    default = { };
  };

  config = {
    networking.firewall.interfaces."lan0".allowedTCPPorts = [
      80
      443
    ];
    networking.firewall.interfaces."tailscale0".allowedTCPPorts = [
      80
      443
    ];

    users.users.traefik.extraGroups = lib.mkIf config.virtualisation.podman.enable [ "podman" ];

    services.traefik = {
      enable = true;
      useEnvSubst = false;
      environmentFiles = [ "/var/lib/traefik/traefik.env" ];

      static.settings = {
        api.dashboard = true;

        certificatesResolvers.cloudflare.acme = {
          dnschallenge.provider = "cloudflare";
          email = "wietsedv@proton.me";
          storage = "/var/lib/traefik/acme.json";
        };

        entryPoints = {
          web = {
            address = ":80";
            http.redirections.entrypoint = {
              to = "websecure";
              scheme = "https";
            };
          };
          websecure = {
            address = ":443";
            http.middlewares = [ "sts-header@file" ];
            http.tls = {
              certResolver = "cloudflare";
              domains = [
                { main = domain; }
                { main = "*.${domain}"; }
              ];
            };
          };
        };
      };

      dynamic = {
        dir = "/var/lib/traefik/dynamic";

        files.web-apps.settings = {
          http = lib.mkMerge [
            {
              middlewares = {
                sts-header.headers = {
                  stsSeconds = 15552000;
                };
              };
              routers = {
                traefik = {
                  rule = "Host(`traefik.${domain}`)";
                  service = "api@internal";
                };
              };
            }
            {
              routers = (
                lib.mapAttrs (n: v: {
                  rule = "Host(`${n}.${domain}`)";
                  service = "${n}";
                }) enabledWebApps
              );
              services = (
                lib.mapAttrs (n: v: {
                  loadBalancer.servers = lib.singleton { url = "http://${v.host}:${toString v.port}"; };
                }) enabledWebApps
              );
            }
            {
              routers = (
                lib.mapAttrs (name: app: {
                  rule = "Host(`${name}.${domain}`)";
                  service = "${name}";
                }) config.custom.web-apps
              );
              services = (
                lib.mapAttrs (name: app: {
                  loadBalancer.servers = lib.singleton { url = "http://127.0.0.1:${toString app.port}"; };
                }) config.custom.web-apps
              );
            }
          ];
        };
      };
    };
  };
}
