# vim: set sw=2 et :

# to activate, use
# 
#    sudo nixos-rebuild switch
#

{
  description = "Personal NixOS/home-manager config flake";

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

      user = {
        name  = "bart";
        full  = "Bart Trojanowski";
        email = "bart@jukie.net";
      };

      pkgs = import nixpkgs {
        inherit nixpkgs; #.legacyPackages.${system};
        config = { allowUnfree = true; };
      };
      lib = nixpkgs.lib;
    in {

      nixosConfigurations = (
        import ./hosts {
          inherit (nixpkgs) lib;
          inherit inputs user system home-manager;
        }
      );

      homeConfigurations."bart" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        modules = [
          ./hosts/thinkpad/home.nix
        ];

        extraSpecialArgs = {
          name = "${user.name}";
          #home = "/home/${user.name}";
          inherit inputs user system;
        };

      };

    };
}
