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
      #url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    #nix-index-database = {
    #  url = "github:Mic92/nix-index-database";
    #  inputs.nixpkgs.follows = "nixpkgs";
    #};
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs:
    let
      user = {
        name  = "bart";
        full  = "Bart Trojanowski";
        email = "bart@jukie.net";
      };
      myconf = {
        # ultimately I plan on converting this to a more structured thing with defaults
        desktop = {
          plasma.enable = true;
          hyprland.enable = true;
          hyprland.withUWSM = true;
        };
        terminal = {
          plasma.enable = false;
          hyprland.enable = false;
          hyprland.withUWSM = false;
        };
      };

    in {

      # ---- nixos configurations ----

      nixosConfigurations = (
        import ./hosts {
          system = if builtins ? currentSystem then builtins.currentSystem else "x86_64-linux";
          myconf = myconf.desktop;
          inherit (nixpkgs) lib;
          inherit inputs user home-manager;
        }
      );

      # ---- home-manager configurations ----

      homeConfigurations."bart@thinkpad" = let
        system = "x86_64-linux";
        myconf = myconf.desktop;
      in home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.${system};

        modules = [
            ./hosts/thinkpad/home.nix
            #nix-index-database.nixosModules.nix-index
        ];

        extraSpecialArgs = {
          name = "${user.name}";
          #home = "/home/${user.name}";
          inherit inputs user myconf system;
        };

      };

      homeConfigurations."bart@raspberrypi" = let
        system = "aarch64-linux";
        myconf = myconf.terminal;
      in home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.${system};

        modules = [
            ./hosts/raspberrypi/home.nix
            #nix-index-database.nixosModules.nix-index
        ];

        extraSpecialArgs = {
          name = "${user.name}";
          #home = "/home/${user.name}";
          inherit inputs user myconf system;
        };

      };

    };
}
