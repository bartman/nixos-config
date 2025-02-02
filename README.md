# This project

This repo captures the configuration for my machines running NixOS, or just home-manager
on some other system, like Ubuntu or Debian.  I wanted a single repo where I can run
`make` to do the right thing to update my configuration.

## TL;DR

*I'm new, but I don't want to read.*

- edit configuration
  - edit `flake.nix` this is where the hosts/user are defined
  - populate `hosts` directory accordingly
    - all hosts have a `home.nix` for `home-manager`
    - NixOS hosts have a `configuration.nix` and `hardware-configuration.nix` as well
  - run `git grep bart` ... edit those files, set your name
- if you're not on NixOS...
  - Debian or Ubuntu...
    ```sh
    sudo apt install nix-bin nix-setup-systemd
    sudo adduser $(id -n -u) nix-users
    sudo systemctl start nix-daemon.service
    ```
  - anything else...
    ```sh
    sudo install -d -m755 -o $(id -u) -g $(id -g) /nix
    curl -L https://nixos.org/nix/install | sh
    ```
  - then initialize your `~/.config/home-manager/` files...
    ```sh
    make init
    ```
- then deploy the configuration
    ```sh
    make
    ```

## hosts

- `thinkpad` is my laptop (*amd64*)
- `raspberrypi` is my laptop (*aarch64*)

## layout
```
.
├── Makefile                                   -- launch script
├── flake.nix                                  -- top level config
├── flake.lock                                 -- captures install hashes
├── hosts
│   ├── default.nix                            -- host entry point
│   ├── thinkpad
│   │   ├── configuration.nix                  -- thinkpad host config
│   │   ├── hardware-configuration.nix         -- thinkpad hardware config
│   │   └── home.nix                           -- home-manager config
│   └── raspberrypi
│       └── home.nix                           -- home-manager config
└── modules
    └── starship-prompt.nix                    -- starship prompt config
```

## the Makefile

The Makefile just serves as a script that executes the `nixos-rebuild` or `home-manager`
commands with the appropriate options.  The following targets are available:

| command       | what it does |
|---------------|--------------|
| make          | same as switch rule |
| make DRYRUN=1 | only print what woudl be ran |
| make init     | initialize non-NixOS for `home-manager` |
| make build    | only build   |
| make test     | build and test |
| make switch   | build and switch to it |


On NixOS, this runs...
```sh
sudo nixos-rebuild ${ACTION} --flake "${PWD}#"
```

If it's something else it runs...
```sh
nix run home-manager -- ${ACTION} --flake "${PWD}/#${USER}@${HOST}"
```




# NOTES

Some random notes below.  Probably all wrong and outdated.  Need to review and cleanup.

This config can be used to rebuild my system.  You may want to replace "bart" with your name.

Note that some config files may reference `~/etc/` where I keep my custom configs, not yet ported to home-manager.

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

# resources

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
