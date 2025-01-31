# vim: set sw=2 et :

{ lib, inputs, system, home-manager, user, ... }:

{
  thinkpad = lib.nixosSystem {
    inherit system;
    specialArgs = {inherit user inputs;};
    modules = [
      ./thinkpad/configuration.nix
      home-manager.nixosModules.home-manager {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.extraSpecialArgs = { inherit user; };
          home-manager.backupFileExtension = "backup";
          home-manager.users.${user.name} = { config, pkgs, user, ... }: {
            home.username = user.name;
            home.homeDirectory = "/home/${user.name}";
            imports = [ ./thinkpad/home.nix ];

            # nix has no problems importing multiple files like above
            # this magic [()] ++ [()] is only needed if some are directories and others are nix files
            # imports = [(import ./home.nix)] ++ [(import ./thinkpad/home.nix)];
          };
      }
    ];
  };
}
