# vim: set sw=2 et :

{ config, pkgs, inputs, user, ... }:

{
  imports =
    [
      # https://nixos.wiki/wiki/Scanners
      #<nixpkgs/nixos/modules/services/hardware/sane_extra_backends/brscan4.nix>
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "thinkpad"; # Define your hostname.

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

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.wireless.enable = false;  # not wpa_supplicant, using networkmanager instead
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Toronto";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_CA.UTF-8";

  # avahi
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    domainName = "local";
    publish = {
      enable = true;
      addresses = true;
      workstation = true;
      userServices = true;
    };
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;

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

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;
  services.printing.browsed.enable = true;

  hardware.sane = {
    enable = true;
    extraBackends = [ pkgs.sane-airscan ];
    brscan4 = {
      enable = true;
      netDevices = {
        home = { model = "MFC-L3780"; ip = "192.168.2.104"; };
      };
    };
  };

  # flatpak
  services.flatpak.enable = true;
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  # fonts
  fonts.packages = with pkgs; [
    source-code-pro
    font-awesome
    #corefonts
    terminus_font
    terminus_font_ttf
    nerd-fonts.terminess-ttf
    nerd-fonts.fira-mono
  ];

  # Enable bluetooth
  hardware.bluetooth.enable = true;

  # Enable sound with pipewire.
  # https://nixos.wiki/wiki/PipeWire
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    wireplumber.enable = true;

    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  security = {
    sudo.wheelNeedsPassword = false;
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment = {
    variables = {
      TERMINAL = "kitty";
      EDITOR = "nvim";
      VISUAL = "nvim";
    };
    systemPackages = with pkgs; [
      mfcl3770cdwlpr
      brscan4
      sof-firmware

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

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  programs.zsh.enable = true;
  programs.mtr.enable = true;

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = true;
      X11Forwarding = true;
      PermitRootLogin = "no";
    };
  };

  programs.steam = {
    enable = true;
  };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?

}
