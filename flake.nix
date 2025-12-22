{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    elephant = {
      url = "github:abenz1267/elephant";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    lanzaboote = {
      # https://github.com/nix-community/lanzaboote/releases
      url = "github:nix-community/lanzaboote/v0.4.3";
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

    walker = {
      url = "github:abenz1267/walker";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.elephant.follows = "elephant";
    };
  };

  outputs =
    {
      nixpkgs,
      home-manager,
      lanzaboote,
      nix-darwin,
      sops-nix,
      ...
    }@inputs:
    {
      nixosConfigurations.thinkpad = nixpkgs.lib.nixosSystem {
        modules = [
          home-manager.nixosModules.home-manager
          lanzaboote.nixosModules.lanzaboote
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users.wietse = ./hosts/thinkpad/home.nix;
              extraSpecialArgs = { inherit inputs; };
            };
          }
          ./hosts/thinkpad/configuration.nix
        ];
      };

      darwinConfigurations.macbook = nix-darwin.lib.darwinSystem {
        modules = [
          home-manager.darwinModules.home-manager
          {
            home-manager = {
              sharedModules = [ sops-nix.homeManagerModules.sops ];
              useGlobalPkgs = true;
              useUserPackages = true;
              users.wietse = ./hosts/macbook/home.nix;
            };
          }
          ./hosts/macbook/configuration.nix
        ];
      };
    };
}
