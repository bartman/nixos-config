Some random notes below.  Probably all wrong and outdated.  Need to review and cleanup.

This config can be used to rebuild my system.  You may want to replace "bart" with your name.

Note that some config files may reference `~/etc/` where I keep my custom configs, not yet ported to home-manager.

## layout
```
.
├── flake.nix                                  -- top level config
├── flake.lock                                 -- captures install hashes
├── hosts
│   ├── default.nix                            -- host entry point
│   ├── configuration.nix                      -- general host config
│   ├── home.nix                               -- home-manager config
│   └── thinkpad
│       ├── configuration.nix                  -- thinkpad host config
│       ├── hardware-configuration.nix         -- thinkpad hardware config
│       └── home.nix                           -- home-manager config
└── modules
    └── starship-prompt.nix                    -- starship prompt config
```

## deploy config

Place the configs in `~/nixos/` then run
```sh
	$ sudo nixos-rebuild switch --flake ~/nixos/#
```
or
```sh
	$ sudo nixos-rebuild switch --flake ~/nixos#<hostname>
```

Or, place the configs in `/etc/nixos/` then run

```sh
        $ cd /etc/nixos
        $ sudo nixos-rebuild switch
```
or

## upgrade packages

```sh
        $ cd /etc/nixos
        $ sudo nix flake update
```
or
```sh
	$ sudo nixos-rebuild switch --upgrade --flake /etc/nixos#<hostname>
```

## installing from flake

```sh
        $ nix-env -iA nixos.git
        $ git clone ...github...repo ./path
        $ nixos-install --falke ./path#hostname
        $ reboot
```
then
```sh
        $ sudo rm -f /etc/nixos/configuration.nix
```

## useful commands

- store location where package is found
``` sh
$ nix eval --inputs-from ~/nixos --raw "nixpkgs#neovim"
```
- list all files in a package
``` sh
$ fd . $(nix eval --inputs-from ~/nixos --raw "nixpkgs#neovim")
```
- reducing space in the store
```sh
$ nix store gc
$ nix store optimise
```

## update channels

NOTE: channels are not needed with flakes.  This used to be a thing, now is discouraged

```sh
	$ nix-channel --add https://nixos.org/channels/nixos-24.11

	$ nix-channel --list 
	nixos-24.11 https://nixos.org/channels/nixos-24.11

	$ nix-channel --update
	unpacking 1 channels...
```

## resources

- Matthias Benaets
    - https://github.com/MatthiasBenaets/nix-config
    - https://www.youtube.com/watch?v=AGVXJ-TIv3Y
- Sascha Koenig
    - https://code.m3tam3re.com/m3tam3re/nixcfg
    - https://www.youtube.com/watch?v=OFGyKMSJzXY
- NixOS docs
    - Packages/options: https://search.nixos.org/packages
    - Home Manager: https://home-manager-options.extranix.com
    - Wiki: https://nixos.wiki/wiki/Main_Page
        - Cheatsheet: https://wiki.nixos.org/wiki/Cheatsheet
