# CLAUDE.md

## Repo structure

NixOS + nix-darwin + home-manager flake. Hosts: `thinkpad` (NixOS laptop),
`macbook` (darwin), and servers `luna`, `mars`, `terra`.

- `flake.nix`: inputs, host definitions, per-host overlays. Servers built via
  the `makeServer` helper; clients spelled out.
- `recursive-imports.nix`: module discovery. All of `config/` is walked; no
  file is imported by hand.
- `config/`: every module, grouped by concern: `applications+client/`,
  `desktop+client/`, `networking/`, `programs/`, `services+terra/`, `shell/`,
  `system/`.
- `secrets/secrets.yaml`: sops-nix encrypted.
- `build.sh <host>`: builds a server's config on that server itself
  (`nixos-rebuild build --target-host --build-host`). Local host: plain
  `nixos-rebuild`.

### Module naming rules (enforced by recursive-imports.nix)

A file or directory is imported only if its name passes both checks:

- **Targets**: `+` in the basename restricts it. `foo+client.nix` is imported
  only for hosts whose target list contains `client`; `foo+mars+terra.nix` for
  either. Directories work the same way (`config/services+terra/`), and a
  filtered-out directory prunes its whole subtree. No `+` means always.
- **Suffix**: `.nix` becomes a NixOS/darwin module, `.home.nix` a
  home-manager module. Any other dot in the name means the file is skipped, so
  a `.home.nix` file is invisible to the system pass and vice versa.

Targets per host are the `targets` list in `flake.nix` (e.g. thinkpad:
`thinkpad`, `client`, `nixos`).

Adding config = drop a correctly named file into the right `config/`
subdirectory. Nothing else to register.

## Temporary workarounds must warn at rebuild

Any workaround for an upstream bug (patched vendored source, pinned old
revision, disabled feature, overridden derivation) must print a warning on
every `nixos-rebuild` / `darwin-rebuild`, not just carry a code comment. A
silent workaround gets forgotten and outlives the bug.

Use `lib.warn` around the value the workaround produces, so it fires during
evaluation:

```nix
src = lib.warn "playwright: local workaround active, ... Drop this overlay once upstream ships the fix." (
  pkgs.runCommand "patched-src" { } ''...''
);
```

The message must say: what is patched, why upstream needs it, and the
condition for removing it.

Where possible, also make the patch fail loudly if it stops applying (e.g.
`grep -q <injected-thing> $out/file` after a `sed`), so an upstream rename
breaks the build instead of silently doing nothing.
