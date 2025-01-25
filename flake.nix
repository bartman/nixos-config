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

  outputs = { self, nixpkgs, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      lib = nixpkgs.lib;
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
            inputs.home-manager.nixosModules.default

          ];
        };
      };
    };
}
