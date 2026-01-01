{
  config,
  lib,
  pkgs,
  ...
}:

let
  defaultSettings = {
    bridge = {
      permissions = {
        "${config.globalDomain}" = "user";
        "@wietse:${config.globalDomain}" = "admin";
      };
    };
    backfill.enabled = true;
    double_puppet.secrets = {
      "${config.globalDomain}" = "as_token:OophieTh4Eid8Ti9me7eituigeireete8poo1liu7fe1Aiph7Oopeikoovooghae";
    };
  };

  bridges = [
    {
      name = "signal";
      package = pkgs.mautrix-signal;
      settings.network = {
        displayname_template = "{{or .Nickname .ContactName .ProfileName .PhoneNumber \"Unknown user\"}} (SG)";
        extev_polls = true;
      };
    }
    # TODO telegram
    {
      name = "whatsapp";
      package = pkgs.mautrix-whatsapp;
      settings.network = {
        displayname_template = "{{if .FullName}}{{.FullName}}{{else}}~ {{or .BusinessName .FirstName .PushName .Phone}}{{end}} (WA)";
        enable_status_broadcast = false;
        history_sync.max_initial_conversations = 20;
      };
    }
  ];
in
{
  nixpkgs.config.permittedInsecurePackages = [ "olm-3.2.16" ];

  systemd.services = builtins.listToAttrs (
    (builtins.map (
      bridge:
      let
        settings = lib.mergeAttrsList [
          {
            database = {
              type = "sqlite3-fk-wal";
              uri = "file:${dataDir}/mautrix-${bridge.name}.db?_txlock=immediate";
            };
            homeserver = {
              address = "http://127.0.0.1:${toString config.services.matrix-continuwuity.settings.global.port}";
              domain = config.services.matrix-continuwuity.settings.global.server_name;
            };
          }
          defaultSettings
          bridge.settings
        ];

        dataDir = "/var/lib/mautrix-${bridge.name}";
        registrationFile = "${dataDir}/${bridge.name}-registration.yaml";
        configFile = "${dataDir}/${bridge.name}-config.yaml";

        staticConfigFile = (pkgs.formats.yaml { }).generate "${bridge.name}-config.yaml" settings;
      in
      {
        name = "mautrix-${bridge.name}";
        value = {
          description = "mautrix-${bridge.name} bridge";

          wantedBy = [ "multi-user.target" ];
          wants = [
            "network-online.target"
            "continuwuity.service"
          ];
          after = [
            "network-online.target"
            "continuwuity.service"
          ];

          preStart = ''
            test -f '${configFile}' && rm -f '${configFile}'
            # old_umask=$(umask)

            # generate the appservice's registration file if absent
            if [ ! -f '${registrationFile}' ]; then
              cp '${staticConfigFile}' '${configFile}'
              ${bridge.package}/bin/mautrix-${bridge.name} \
                --generate-registration \
                --config='${configFile}' \
                --registration='${registrationFile}'
            fi
            chmod 640 ${registrationFile}

            # overwrite registration tokens in config
            ${pkgs.yq}/bin/yq -s '.[0].appservice.as_token = .[1].as_token
              | .[0].appservice.hs_token = .[1].hs_token
              | .[0]' '${staticConfigFile}' '${registrationFile}' > '${configFile}'
          '';

          serviceConfig = {
            ExecStart = ''
              ${bridge.package}/bin/mautrix-${bridge.name} \
                --config='${configFile}' \
                --registration='${registrationFile}'
            '';

            Type = "simple";
            Restart = "always";

            ProtectSystem = "strict";
            ProtectHome = true;
            ProtectKernelTunables = true;
            ProtectKernelModules = true;
            ProtectControlGroups = true;

            DynamicUser = true;
            PrivateTmp = true;
            StateDirectory = baseNameOf dataDir;
            UMask = "0027";

            WorkingDirectory = dataDir;
          };
        };
      }
    ) bridges)
  );
}
