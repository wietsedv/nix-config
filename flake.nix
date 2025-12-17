{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/master";
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
  };

  outputs =
    {
      home-manager,
      nix-darwin,
      sops-nix,
      ...
    }:
    {
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
