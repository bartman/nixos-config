# to activate, use
# 
#    sudo nixos-rebuild switch
#

{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.11";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs:
    let
    system = "x86_64-linux";
  pkgs = import nixpkgs {
    inherit nixpkgs; #.legacyPackages.${system};
    config = { allowUnfree = true; };
  };
  lib = nixpkgs.lib;
  username = "bart";
  in
  {
    nixosConfigurations = {
      # configuration for each host...
      default = lib.nixosSystem {
        specialArgs = {inherit inputs;};
        modules = [
          ./configuration.nix
            inputs.home-manager.nixosModules.default

        ];
      };
      thinkpad = lib.nixosSystem {
        specialArgs = {inherit inputs;};
        modules = [
          ./configuration.nix
          home-manager.nixosModules.home-manager {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.${username} = import ./home.nix;
          }
        ];
      };
    };
  };
}
