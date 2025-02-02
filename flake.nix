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
      user = {
        name  = "bart";
        full  = "Bart Trojanowski";
        email = "bart@jukie.net";
        plasma.enable = true;
        hyprland.enable = false;
      };

      #lib = nixpkgs.lib;
    in {
      nixosConfigurations = (
        import ./hosts {
          system = if builtins ? currentSystem then builtins.currentSystem else "x86_64-linux";
          inherit (nixpkgs) lib;
          inherit inputs user home-manager;
        }
      );

      homeConfigurations."bart@thinkpad" = let
        system = "x86_64-linux";
      in home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.${system};

        modules = [
          ./hosts/thinkpad/home.nix
        ];

        extraSpecialArgs = {
          name = "${user.name}";
          #home = "/home/${user.name}";
          inherit inputs user system;
        };

      };

      homeConfigurations."bart@raspberrypi" = let
        system = "aarch64-linux";
      in home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.${system};

        modules = [
          ./hosts/raspberrypi/home.nix
        ];

        extraSpecialArgs = {
          name = "${user.name}";
          #home = "/home/${user.name}";
          inherit inputs user system;
        };

      };

    };
}
