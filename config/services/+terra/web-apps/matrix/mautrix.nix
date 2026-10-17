{
  config,
  lib,
  pkgs,
  ...
}:

let
  mautrix-telegram = pkgs.buildGoModule rec {
    pname = "mautrix-telegram";
    version = "26.09";
    tag = "v0.2609.0";

    src = pkgs.fetchFromGitHub {
      owner = "mautrix";
      repo = "telegram";
      inherit tag;
      hash = "sha256-M8kQap14MRh3tlqOe7JxLkJlsNsJY/COztv0AqvdgF0=";
    };

    vendorHash = "sha256-qW/v/QmhQRF2SAMUNXE2mfVGVEp+DU3gESWVRKHqfGM=";

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

  # Upstream hardcodes the network icon as an mxc://maunium.net URI, which
  # this homeserver can't fetch (federation is off). Read it from
  # MAUTRIX_NETWORK_ICON instead, set to a locally uploaded copy at start.
  withLocalNetworkIcon =
    package:
    package.overrideAttrs (old: {
      postPatch = (old.postPatch or "") + ''
        sed -i 's|"mxc://maunium.net/[A-Za-z0-9]*"|localNetworkIcon|' pkg/connector/connector.go
        grep -q 'NetworkIcon: *localNetworkIcon,' pkg/connector/connector.go
        cat > pkg/connector/localnetworkicon.go <<'EOF'
        package connector

        import (
        	"os"

        	"maunium.net/go/mautrix/id"
        )

        var localNetworkIcon = id.ContentURIString(os.Getenv("MAUTRIX_NETWORK_ICON"))
        EOF
      '';
    });

  # The bridge logo shipped in each repo, rendered to PNG for clients.
  iconFor =
    name: package:
    pkgs.runCommand "mautrix-${name}-icon.png" { nativeBuildInputs = [ pkgs.librsvg ]; } ''
      rsvg-convert --width 512 --height 512 --keep-aspect-ratio ${package.src}/.idea/icon.svg -o $out
    '';

  bridges = [
    {
      name = "signal";
      package = pkgs.mautrix-signal;
      iconSettings = [ ".network.note_to_self_avatar" ];
      settings.network = {
        displayname_template = "{{or .Nickname .ContactName .ProfileName .PhoneNumber \"Unknown user\"}} (SG)";
        extev_polls = true;
      };
    }
    {
      name = "telegram";
      package = mautrix-telegram;
      iconSettings = [ ".network.saved_message_avatar" ];
      settings.network = {
        displayname_template = "{{ if .Deleted }}Deleted account {{or .Username .UserID }}{{ else }}{{if .FullName}}{{.FullName}}{{else}}~ {{or .Username .UserID }}{{end}}{{ end }} (TG)";
      };
    }
    {
      name = "whatsapp";
      package = pkgs.mautrix-whatsapp;
      iconSettings = [ ];
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
        package = withLocalNetworkIcon bridge.package;
        icon = iconFor bridge.name bridge.package;
        homeserverAddress = "http://127.0.0.1:${toString config.services.matrix-continuwuity.settings.global.port}";

        settings = lib.mergeAttrsList [
          {
            database = {
              type = "sqlite3-fk-wal";
              uri = "file:${dataDir}/mautrix-${bridge.name}.db?_txlock=immediate";
            };
            homeserver = {
              address = homeserverAddress;
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
        iconMxcFile = "${dataDir}/icon.mxc";
        iconSrcFile = "${dataDir}/icon.src";

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
              ${package}/bin/mautrix-${bridge.name} \
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

            # upload the bridge icon to the local homeserver once per icon
            if [ "$(cat '${iconSrcFile}' 2>/dev/null)" != '${icon}' ]; then
              as_token=$(${pkgs.yq}/bin/yq -r .as_token '${registrationFile}')
              if icon_mxc=$(${pkgs.curl}/bin/curl -sSf -X POST \
                  -H "Authorization: Bearer $as_token" \
                  -H 'Content-Type: image/png' \
                  --data-binary @'${icon}' \
                  '${homeserverAddress}/_matrix/media/v3/upload?filename=${bridge.name}.png' \
                  | ${pkgs.jq}/bin/jq -er .content_uri); then
                echo "$icon_mxc" > '${iconMxcFile}'
                echo '${icon}' > '${iconSrcFile}'
              else
                echo "mautrix-${bridge.name}: failed to upload bridge icon" >&2
              fi
            fi

            # point all avatar settings at the local icon
            if [ -f '${iconMxcFile}' ]; then
              ICON_MXC=$(cat '${iconMxcFile}') ${pkgs.yq-go}/bin/yq -i '${
                lib.concatMapStringsSep " | " (path: "${path} = strenv(ICON_MXC)") (
                  [ ".appservice.bot.avatar" ] ++ bridge.iconSettings
                )
              }' '${configFile}'
            fi
          '';

          serviceConfig = {
            ExecStart = pkgs.writeShellScript "mautrix-${bridge.name}-start" ''
              MAUTRIX_NETWORK_ICON=$(cat '${iconMxcFile}' 2>/dev/null || true)
              export MAUTRIX_NETWORK_ICON
              exec ${package}/bin/mautrix-${bridge.name} \
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
