Some random notes below.  Probably all wrong and outdated.  Need to review and cleanup.

This config can be used to rebuild my system.  You may want to replace "bart" with your name.

Note that some config files may reference `~/etc/` where I keep my custom configs, not yet ported to home-manager.

## deploy config

```sh
        $ cd /etc/nixos
        $ sudo nixos-rebuild switch
```
or
```sh
	$ sudo nixos-rebuild switch --flake /etc/nixos#<hostname>
```

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

## update channels

NOTE: channels are not needed with flakes

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
