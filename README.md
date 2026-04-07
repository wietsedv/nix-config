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
