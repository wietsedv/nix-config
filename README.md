# Nix Config

These are the configurations of my NixOS and nix-darwin laptops and servers. Hosts are defined in [`flake.nix`](/flake.nix); everything else is automatically imported from [`config/`](/config).

Directories and Nix files in `config/` can carry `+target` markers to restrict them to hosts with that target, e.g. `programs/containers/docker+thinkpad.nix` or `services/+terra/`. Files ending in `.home.nix` are home-manager modules, other `.nix` files are NixOS/nix-darwin modules. See [`CLAUDE.md`](/CLAUDE.md) for the full rules and where new config goes.

## Hosts
- **💻 clients**
    - 🍎 macbook
    - 🍏 thinkpad
- **🚀 servers**
    - 🌎 terra (primary home server)
    - 🔴 mars (off site backup server)
    - 🌓 luna (small vps)
