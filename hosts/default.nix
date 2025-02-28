# vim: set sw=2 et :

{ lib, inputs, system, home-manager, user, myconf, ... }:

{
  thinkpad = lib.nixosSystem {
    inherit system;
    specialArgs = {inherit user myconf inputs;};
    modules = [
      ./thinkpad/configuration.nix

      # this adds the nix-index package
      inputs.nix-index-database.nixosModules.nix-index
      { programs.nix-index-database.comma.enable = true; }

      home-manager.nixosModules.home-manager {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.extraSpecialArgs = { inherit user myconf inputs; };
        home-manager.backupFileExtension = "backup";
        home-manager.users.${user.name} = { user, ... }: {
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
