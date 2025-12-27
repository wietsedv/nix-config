{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    lanzaboote = {
      url = "github:nix-community/lanzaboote/v1.0.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-darwin = {
      url = "github:LnL7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    private = {
      url = "git+ssh://git@github.com/wietsedv/nix-config-private.git?ref=main";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.disko.follows = "disko";
    };

    # Walker
    elephant = {
      url = "github:abenz1267/elephant";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    walker = {
      url = "github:abenz1267/walker";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.elephant.follows = "elephant";
      inputs.systems.follows = "elephant/systems";
    };
  };

  outputs =
    { nixpkgs, nix-darwin, ... }@inputs:
    {
      # clients
      darwinConfigurations.macbook = nix-darwin.lib.darwinSystem {
        modules = [
          inputs.home-manager.darwinModules.home-manager
          ./hosts/+macbook/configuration.nix
        ];
      };
      nixosConfigurations.thinkpad = nixpkgs.lib.nixosSystem {
        modules = [
          inputs.home-manager.nixosModules.home-manager
          inputs.lanzaboote.nixosModules.lanzaboote
          {
            home-manager.sharedModules = [
              inputs.walker.homeManagerModules.default
            ];
          }
          ./hosts/+thinkpad/configuration.nix
        ];
      };

      # servers
      nixosConfigurations.terra = nixpkgs.lib.nixosSystem {
        modules = [
          inputs.private.nixosModules.terra
          ./hosts/+terra/configuration.nix
        ];
      };
      nixosConfigurations.mars = nixpkgs.lib.nixosSystem {
        modules = [
          ./hosts/+mars/configuration.nix
        ];
      };
      nixosConfigurations.luna = nixpkgs.lib.nixosSystem {
        modules = [
          inputs.disko.nixosModules.disko
          ./hosts/+luna/configuration.nix
        ];
      };
    };
}
