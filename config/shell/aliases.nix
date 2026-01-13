{ pkgs, ... }:

{
  environment.shellAliases = {
    ter = "ssh terra";
    mar = "ssh mars";
    lun = "ssh luna";

    nr = if pkgs.stdenv.isLinux then "nixos-rebuild switch --sudo" else "sudo darwin-rebuild switch";
    nrb = "nixos-rebuild boot --sudo";
    nrt = "nixos-rebuild test --sudo";

    nf = "nix flake update";
    nfr = "nf && nr";
    nfrt = "nf && nrt";
  };
}
