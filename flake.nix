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

    # Walker
    systems.url = "github:nix-systems/x86_64-linux";
    elephant = {
      url = "github:abenz1267/elephant";
      inputs.systems.follows = "systems";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    walker = {
      url = "github:abenz1267/walker";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.systems.follows = "systems";
      inputs.elephant.follows = "elephant";
    };
  };

  outputs =
    {
      nixpkgs,
      disko,
      home-manager,
      lanzaboote,
      nix-darwin,
      walker,
      ...
    }:
    {
      # clients
      darwinConfigurations.macbook = nix-darwin.lib.darwinSystem {
        modules = [
          home-manager.darwinModules.home-manager
          ./hosts/+macbook/configuration.nix
        ];
      };
      nixosConfigurations.thinkpad = nixpkgs.lib.nixosSystem {
        modules = [
          home-manager.nixosModules.home-manager
          lanzaboote.nixosModules.lanzaboote
          {
            home-manager.sharedModules = [
              walker.homeManagerModules.default
            ];
          }
          ./hosts/+thinkpad/configuration.nix
        ];
      };

      # servers
      nixosConfigurations.terra = nixpkgs.lib.nixosSystem {
        modules = [
          ./hosts/+luna/configuration.nix
        ];
      };
      nixosConfigurations.mars = nixpkgs.lib.nixosSystem {
        modules = [
          ./hosts/+mars/configuration.nix
        ];
      };
      nixosConfigurations.luna = nixpkgs.lib.nixosSystem {
        modules = [
          disko.nixosModules.disko
          ./hosts/+luna/configuration.nix
        ];
      };
    };
}
