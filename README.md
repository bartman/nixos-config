## deploy config

        $ cd /etc/nixos
        $ sudo nixos-rebuild switch
    or
	$ sudo nixos-rebuild switch --flake /etc/nixos#<hostname>

## upgrade packages

        $ cd /etc/nixos
        $ sudo nix flake update
    or
	$ sudo nixos-rebuild switch --upgrade --flake /etc/nixos#<hostname>

## installing from flake

        $ nix-env -iA nixos.git
        $ git clone ...github...repo ./path
        $ nixos-install --falke ./path#hostname
        $ reboot
    then
        $ sudo rm -f /etc/nixos/configuration.nix

## update channels

    channels are not needed with flakes

	$ nix-channel --add https://nixos.org/channels/nixos-24.11

	$ nix-channel --list 
	nixos-24.11 https://nixos.org/channels/nixos-24.11

	$ nix-channel --update
	unpacking 1 channels...

## resources

    - YouTube: Matthias Benaets
