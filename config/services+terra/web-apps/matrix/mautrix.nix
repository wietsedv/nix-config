{
  config,
  lib,
  pkgs,
  ...
}:

let
  mautrix-telegram = pkgs.buildGoModule rec {
    pname = "mautrix-telegram";
    version = "26.05";
    tag = "v0.2605.0";

    src = pkgs.fetchFromGitHub {
      owner = "mautrix";
      repo = "telegram";
      inherit tag;
      hash = "sha256-9TCXyGvFCZAv8xIUW3oiVRv5EBdObrLuALfME/oAWBE=";
    };

    vendorHash = "sha256-xcBbBIsFXQ90WyQ8OY+CCVIiBepIlOD/o+ZjabNvM0Q=";

    ldflags = [
      "-X"
      "main.Tag=${tag}"
    ];

    buildInputs = [
      pkgs.olm
      pkgs.stdenv.cc.cc.lib
    ];

    doCheck = false;
  };

  defaultSettings = {
    bridge = {
      permissions = {
        "${config.globalDomain}" = "user";
        "@wietse:${config.globalDomain}" = "admin";
      };
    };
    backfill.enabled = true;
    double_puppet.secrets = {
      "${config.globalDomain}" =
        "as_token:OophieTh4Eid8Ti9me7eituigeireete8poo1liu7fe1Aiph7Oopeikoovooghae";
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
    {
      name = "telegram";
      package = mautrix-telegram;
      settings.network = {
        displayname_template = "{{ if .Deleted }}Deleted account {{or .Username .UserID }}{{ else }}{{if .FullName}}{{.FullName}}{{else}}~ {{or .Username .UserID }}{{end}}{{ end }} (TG)";
      };
    }
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
        configSecretsFile = "${dataDir}/${bridge.name}-config-secrets.yaml";

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

            # overwrite config with secrets if they exist
            if [ -f "${configSecretsFile}" ]; then
              ${pkgs.yq-go}/bin/yq eval-all 'select(fileIndex == 0) *+ select(fileIndex == 1)' '${configFile}' '${configSecretsFile}' > '${configFile}.tmp'
              rm -f '${configFile}'
              mv '${configFile}.tmp' '${configFile}'
            fi
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
