# Nix Config

These are the configurations of my NixOS and nix-darwin laptops and servers. The machine definitions in `hosts/` are bare minimum configurations. Everything important is dynamically imported from `system/` (NixOS / nix-darwin) and `home/` (Home Manager; only on laptops).

System and home configurations are recursively imported from `system/` and `home/`. The subdirectories that are imported are listed in each `configuration.nix`. Imported subdirectories are typically `+[hostname]`, `laptop`/`server`, and `common`.

## Hosts
- **💻 laptops**
    - [🍎 macbook](/hosts/+macbook/configuration.nix)
    - [🍏 thinkpad](/hosts/+thinkpad/configuration.nix)
- **🚀 servers**
    - [🌎 terra](/hosts/+terra/configuration.nix) (primary home server)
    - [🔴 mars](/hosts/+mars/configuration.nix) (off site backup server)
    - [🌓 luna](/hosts/+luna/configuration.nix) (small vps)

## Todo

- full monorepo
- systemd-networkd
- nixos-containers
- lix
- continuwuity
- deploy-rs / colmena
- [server store via nix.sshServe](https://docs.lix.systems/manual/lix/stable/package-management/ssh-substituter.html)
- forgejo
- forgejo actions

