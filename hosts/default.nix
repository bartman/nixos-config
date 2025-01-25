# vim: set sw=2 et

{ lib, inputs, system, home-manager, user, ... }:

{
  thinkpad = lib.nixosSystem {
    inherit system;
    specialArgs = {inherit user inputs;};
    modules = [
      ./configuration.nix
      ./thinkpad/configuration.nix
      home-manager.nixosModules.home-manager {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.extraSpecialArgs = { inherit user; };
          home-manager.backupFileExtension = "backup";
          home-manager.users.${user.name} = { config, pkgs, user, ... }: {
            home.username = user.name;
            home.homeDirectory = "/home/${user.name}";
            imports = [ ./home.nix ./thinkpad/home.nix ];
            # imports = [(import ./home.nix)] ++ [(import ./thinkpad/home.nix)];
          };
      }
    ];
  };
}
