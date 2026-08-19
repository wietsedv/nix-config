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
      url = "github:nix-community/lanzaboote/v1.1.0";
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

    playwright = {
      url = "github:pietdevries94/playwright-web-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    private = {
      url = "git+ssh://git@github.com/wietsedv/nix-config-private.git?ref=main";
      inputs.nixpkgs.follows = "nixpkgs";
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
    let
      recursiveImports = import ./recursive-imports.nix nixpkgs.lib ./config;

      recursiveModules = {
        default = recursiveImports "";
        home = recursiveImports "home";
      };

      makeServer =
        hostName: modules:
        nixpkgs.lib.nixosSystem {
          modules =
            recursiveModules.default [
              hostName
              "server"
              "nixos"
            ]
            ++ [
              { networking.hostName = hostName; }
              inputs.private.nixosModules.default
            ]
            ++ modules;
        };
    in
    {
      darwinConfigurations.macbook =
        let
          targets = [
            "macbook"
            "client"
          ];
        in
        nix-darwin.lib.darwinSystem {
          modules = recursiveModules.default targets ++ [
            inputs.private.nixosModules.default
            inputs.home-manager.darwinModules.home-manager
            {
              networking.hostName = "macbook";
              home-manager.sharedModules = recursiveModules.home targets;
            }
          ];
        };

      nixosConfigurations = {
        thinkpad =
          let
            targets = [
              "thinkpad"
              "client"
              "nixos"
            ];
          in
          nixpkgs.lib.nixosSystem {
            modules = recursiveModules.default targets ++ [
              inputs.private.nixosModules.default
              inputs.home-manager.nixosModules.home-manager
              inputs.lanzaboote.nixosModules.lanzaboote
              inputs.sops-nix.nixosModules.default
              {
                networking.hostName = "thinkpad";
                nixpkgs.overlays = [
                  (final: prev: {
                    inherit (inputs.playwright.packages.${prev.stdenv.hostPlatform.system}) playwright-test playwright-driver;
                  })
                ];
                home-manager.sharedModules = recursiveModules.home targets ++ [
                  inputs.walker.homeManagerModules.default
                ];
              }
            ];
          };

        luna = makeServer "luna" [ inputs.disko.nixosModules.disko ];
        mars = makeServer "mars" [ ];
        terra = makeServer "terra" [
          inputs.private.nixosModules.terra
        ];
      };
    };
}
