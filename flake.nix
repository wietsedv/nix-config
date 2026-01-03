{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    # nixpkgs-master.url = "github:NixOS/nixpkgs/master";

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
    let
      recursiveImports = import ./recursive-imports.nix nixpkgs.lib ./config;

      recursiveModules = {
        default = recursiveImports "";
        home = recursiveImports "home";
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
            inputs.home-manager.darwinModules.home-manager
            {
              networking.hostName = "macbook";
              home-manager.sharedModules = recursiveModules.home targets;
            }
          ];
        };

      nixosConfigurations.thinkpad =
        let
          targets = [
            "thinkpad"
            "client"
            "nixos"
          ];
        in
        nixpkgs.lib.nixosSystem {
          modules = recursiveModules.default targets ++ [
            inputs.home-manager.nixosModules.home-manager
            inputs.lanzaboote.nixosModules.lanzaboote
            {
              networking.hostName = "thinkpad";
              home-manager.sharedModules = recursiveModules.home targets ++ [
                inputs.walker.homeManagerModules.default
              ];
            }
          ];
        };
    }
    // {
      nixosConfigurations =
        let
          makeServer =
            hostName: modules:
            nixpkgs.lib.nixosSystem {
              modules =
                recursiveModules.default [
                  hostName
                  "server"
                  "nixos"
                ]
                ++ [ { networking.hostName = hostName; } ]
                ++ modules
                ++ [
                  # {
                  #   nixpkgs.overlays = [
                  #     (
                  #       final: prev:
                  #       let
                  #         pkgs-master = inputs.nixpkgs-master.legacyPackages.${prev.stdenv.hostPlatform.system};
                  #       in
                  #       {
                  #         audiobookshelf = pkgs-master.audiobookshelf; # https://nixpkgs-tracker.ocfox.me/?pr=475939
                  #         actual-server = pkgs-master.actual-server; # https://nixpkgs-tracker.ocfox.me/?pr=475880
                  #       }
                  #     )
                  #   ];
                  # }
                ];
            };
        in
        {
          luna = makeServer "luna" [ inputs.disko.nixosModules.disko ];
          mars = makeServer "mars" [ ];
          terra = makeServer "terra" [ inputs.private.nixosModules.terra ];
        };
    };
}
