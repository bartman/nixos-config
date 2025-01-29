# vim: set sw=2 et :

{ config, pkgs, inputs, user, ... }:

{
  imports = [
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Enable networking
  networking.wireless.enable = false;  # not wpa_supplicant, using networkmanager instead
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Toronto";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_CA.UTF-8";

  services.avahi.enable = true;
  services.avahi.domainName = "local";
  services.avahi.publish.workstation = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.${user.name} = {
    isNormalUser = true;
    description = "${user.full}";
    shell = pkgs.zsh;
    extraGroups = [ "networkmanager" "wheel" "video" "audio" "camera" "lp" "scanner" "kvm" "libvirtd" "plex" ];
    #packages = with pkgs; [ ]; # defined in home.nix
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  system.autoUpgrade = {
    enable = true;
    dates = "*-*-* 04:00:00";
    persistent = true;
    allowReboot = false;
    channel = "https://nixos.org/channels/nixos-24.11";
  };

  nix = {
    settings = {
      auto-optimise-store = false;
      experimental-features = [ "nix-command" "flakes" ];
    };
    optimise = {
      automatic = true;
      dates = [ "*-*-* 05:00:00" ];
    };
    gc = {
      automatic = true;
      dates = "*-*-* 03:00:00";
      options = "--delete-older-than 14d";
    };
    #package = pkgs.nixFlakes;                     # enable nixFlakes on system
    registry.nixpkgs.flake = inputs.nixpkgs;
    extraOptions = ''
      keep-outputs      = true
      keep-derivations  = true
    '';
  };


  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment = {
    variables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
    };
    systemPackages = with pkgs; [
      bash
      bat
      difftastic
      fd
      file
      findutils
      fzf
      git
      iftop
      jq
      killall
      gnumake
      home-manager
      mtr
      netcat
      neovim
      netcat
      nix-index
      pciutils
      python310
      python313
      tmux
      tree
      vivid
      usbutils
      wget
    ];
  };

  programs.zsh.enable = true;

  system.stateVersion = "24.11"; # Did you read the comment?

}
