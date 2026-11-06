{ pkgs, lib, ... }:

let
  herdr-core = pkgs.llm-agents.herdr-core;
in
{
  home.packages = [
    herdr-core
  ];

  home.file.".local/bin/herdr-core".source = "${herdr-core}/bin/herdr-core";

  # Hand a running core over to the new build after a rebuild. Programs keep
  # running: their holder stays, only the core is swapped. Skipped when no
  # core runs, since `hc server status` would start one.
  home.activation.herdrCoreRestart = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    if [ -z "''${XDG_RUNTIME_DIR:-}" ] && [ -d "/run/user/$(id -u)" ]; then
      export XDG_RUNTIME_DIR="/run/user/$(id -u)"
    fi
    if ${pkgs.procps}/bin/pgrep -u "$(id -u)" -f '[h]erdr-core serve' >/dev/null; then
      have=$(${herdr-core}/bin/hc server status 2>/dev/null | ${lib.getExe pkgs.jq} -r '.version // empty' || true)
      if [ -n "$have" ] && [ "$have" != "${herdr-core.version}" ]; then
        verboseEcho "herdr-core: restarting core $have -> ${herdr-core.version}"
        run ${herdr-core}/bin/hc server restart >/dev/null || warnEcho "herdr-core: core restart failed"
      fi
    fi
  '';
}
