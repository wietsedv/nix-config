# Nix Config

These are the configurations of my NixOS and nix-darwin laptops and servers. The machine definitions in `hosts/` are bare minimum configurations. Everything important is automatically imported from `config/`.

Directories and Nix files in `config/` can have optional suffixes to mark 

## Hosts
- **💻 clients**
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
- continuwuity
- deploy-rs / colmena
- [server store via nix.sshServe](https://docs.lix.systems/manual/lix/stable/package-management/ssh-substituter.html)
- forgejo
- forgejo actions
- nix-fast-build
- fix filesystems on thinkpad (mount options and /btr_pool)
- check btrfs quota
- fix dns. blocky / Knot Resolver