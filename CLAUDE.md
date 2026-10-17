# CLAUDE.md

## Always `git pull` before making changes

The repo is edited from several machines and dependabot merges PRs upstream,
so the local checkout is often behind. Run `git pull` before touching any
file, so changes aren't made against a stale tree.

## Repo structure

NixOS + nix-darwin + home-manager flake. Hosts: `thinkpad` (NixOS laptop),
`macbook` (darwin), and servers `luna`, `mars`, `terra`.

- `flake.nix`: inputs, host definitions, per-host overlays. Servers built via
  the `makeServer` helper; clients spelled out.
- `recursive-imports.nix`: module discovery. All of `config/` is walked; no
  file is imported by hand.
- `config/`: every module, grouped by concern (see "Where config goes").
- `secrets/secrets.yaml`: sops-nix encrypted.
- `build.sh <host>`: builds a server's config on that server itself
  (`nixos-rebuild build --target-host --build-host`). Local host: plain
  `nixos-rebuild`.

### Module naming rules (enforced by recursive-imports.nix)

A file or directory is imported only if its name passes both checks:

- **Targets**: `+` in the basename restricts it. `foo+client.nix` is imported
  only for hosts whose target list contains `client`; `foo+mars+terra.nix` for
  either. Directories work the same way (`config/services/+terra/`), and a
  filtered-out directory prunes its whole subtree. No `+` means always.
- **Suffix**: `.nix` becomes a NixOS/darwin module, `.home.nix` a
  home-manager module. Any other dot in the name means the file is skipped, so
  a `.home.nix` file is invisible to the system pass and vice versa.

Targets per host are the `targets` list in `flake.nix`:

| Target | Hosts |
|---|---|
| `<hostname>` | that host |
| `client` | thinkpad, macbook |
| `server` | luna, mars, terra |
| `nixos` | thinkpad, luna, mars, terra |
| `dev` | thinkpad, macbook, terra (hosts I develop on, have home-manager) |

Adding config = drop a correctly named file into the right `config/`
subdirectory. Nothing else to register.

### Where config goes

Four top-level directories, which never carry a `+target`. Pick the **first**
that matches:

1. `services/`: provided by this host to other devices: web apps (in
   `web-apps/`, behind traefik), DNS, DHCP, MQTT, databases.
2. `desktop/`: exists only because of a graphical session: WM, bar,
   notifications, lock screen, fonts, theme, key remapping, keyring/polkit.
   GUI apps go in `desktop/apps/`.
3. `programs/`: used from a terminal. Always in a subdirectory, first match:
   - `agents/`: AI agent CLIs and their MCP servers.
   - `shell/`: the interactive environment: zsh, prompt, direnv, file manager.
   - `git/`: git and forge CLIs (gh, glab).
   - `languages/`: compilers, runtimes, LSPs, formatters; one file per language.
   - `containers/`: docker, podman.
   - `tools/`: everything else (`packages.nix` for plain one-liners).
4. `system/`: everything else about the machine: boot, hardware, filesystems,
   backups, users, locale, power, nix, OS-level settings (darwin defaults,
   homebrew setup). Networking and remote access (sshd, tailscale, wireguard)
   in `system/networking/`.

Placing the target:

- Use a `+target/` subdirectory when a concern has 3+ files for that target;
  otherwise suffix the file: `programs/containers/docker+thinkpad.nix`.
- Never repeat an implied target: `+client/foo+thinkpad.nix` is just
  `foo+thinkpad.nix`. Use the narrowest target that is exact (`dev`, not
  `client+terra`).
- A bare `+host.nix` is that host's slice of the concern
  (`system/networking/+luna.nix`, `system/+nixos/hardware/+terra.nix`).

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
