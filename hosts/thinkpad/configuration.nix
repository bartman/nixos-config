# vim: set sw=2 et :

{ config, pkgs, inputs, user, myconf, ... }:

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

  networking.hostName = "thinkpad";

# system.autoUpgrade = {
#   enable = true;
#   dates = "*-*-* 04:00:00";
#   persistent = true;
#   allowReboot = false;
#   channel = "https://nixos.org/channels/nixos-24.11";
# };

  nix = let
    users = [ "root" user.name ];
  in {
    settings = {
      auto-optimise-store = false;
      experimental-features = [ "nix-command" "flakes" ];
      http-connections = 50;
      warn-dirty = false;
      log-lines = 50;
      sandbox = "relaxed";
      trusted-users = users;
      allowed-users = users;
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
  services.displayManager.sddm.wayland.enable = true;

  services.xserver.desktopManager.plasma5.enable = myconf.plasma.enable;

  programs.hyprland = if myconf.hyprland.enable then {
    enable = true;
    xwayland.enable = true;
    withUWSM = myconf.hyprland.withUWSM;
  } else {};

  hardware = {
    graphics.enable = true;
    amdgpu.amdvlk.enable = true;
    amdgpu.amdvlk.support32Bit.enable = true;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.${user.name} = {
    isNormalUser = true;
    description = "${user.full}";
    shell = pkgs.zsh;
    extraGroups = [ "networkmanager" "wheel" "video" "audio" "camera" "lp" "scanner" "kvm" "libvirtd" "plex" ];
    #packages = with pkgs; [ ]; # defined in home.nix

    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCxizMgQGRBkdxDAtpIU6+4kzbvUO2/zokQN1G1q/SHrzVkaahg/kuBHQAK1kfsN1C4XfwZ8t+uMUe7RB/FQAGu9/PvKXzZUtM/jFXKXx3wrXf0JMxnzTdV3JwqvceTpd3MYYpUW50vBsogPP1MzhSVHaE+p0VF13LW9AVqLkpZW3u7jx/1jTJB0K8uBoZdCTi+Unto40nHVU4yVbOBmC8n7uXowuaBqzMNgVtjoXBBFuvIUvpws1/fiRTkwCaqAExIbZQOOQCVEunKOe/OlKX+1KDe9ozoBErzfawqKsqUvMTDrz9lnSg7+WXpZWXq7vW5tIF3hstDcvpAFnOGNvc9q17aK8x1t2wlrhil5rJ2fJgLinfCbrApd0TaVw5PAQfy1SnA9/ZcKr5Qh91wTIPPyfOOvLxaxuASFNObmvBMCsIWrFN+HZPAf21mwI1kagYwcAnWuDdm/gaLr2XrGaUETA//CmurNjsipryjTJazieu1YZIrplQyiQ0rBDDOAx8d/jcShi891uc6bcYmWcW9bPlyYJ3PL2hVzhsYfndq8wUS4x7WDXRdt0ppCKTMkEKTtR+A7iA03+VEX3o87fl+tQiy6/2KUhIoRTdl5LM4oK85NuD8lb6/yivQCdbIENVfwVL1MJwF0xTsISGzqcwQPkQgqXnl2a4q4qJQSZv7dQ== bart@oxygen.jukie.net"
      "ssh-dss AAAAB3NzaC1kc3MAAACBAPUeU2wMGy1ftHDuh6wchqzm4hhAAbJqhHKlQKqpf4dduMzjIoewQA3sZfV2yQnxezTcIFWz1ewVMYbfzzMf7Ozdo2j0zIuolwAof+NMEExSyFXcby7lvnfVbgKR/4hOex04nAB8aZi9sZY1KvM962pME8znz4l07pkOQdDX5s7NAAAAFQDWHyx21lr6uHSClTEJAKdWgtuSBwAAAIBnYm4XfsWcrBn8jjD/FWykSIfgycdKFenN4HxK4iH4/5bdibOZDYkX2l5ExIt/wq9RRbTamkfOYmm0xbXrpuSo1HSfTSIxrQOorE30jJOf/c/ze3Wo5FWx3yDOEym8PiB3yfGtlf6DWhs4/gz7bGHL90FQkqjToxCtmrmcr746RQAAAIAeiTvQYBoU0Weg4niUte+EdxzJxEu8y+LyBK2hFr88fv2FVI2SQ5iUqRQwCWhJ9ZiDAjOHAtHWEQAboccaH1y8XXfHmhB4SOJCZ92JhNnKx8dAWWxdEogYbqFHkZTUb/HsOE8Wt9KdV9ZWvnfPMwDM1dJVCSUCiWWJ/YS8TeizKw== bart@oxygen.jukie.net"
    ];
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

    sessionVariables = if myconf.hyprland.enable then {
      WLR_NO_HARDWARE_CURSORS = "1";
      NIXOS_OZONE_WL = "1";
    } else {};

    systemPackages = with pkgs; [
      home-manager
      mfcl3770cdwlpr
      brscan4
      sof-firmware
      pritunl-client

      zenstates # https://github.com/r4m0n/ZenStates-Linux

    ] ++
      (if myconf.hyprland.enable then with pkgs; [
        kitty
        feh
        #libnotify
        waybar
        #dunst
        #mako
        swww
        wofi
        swaylock
        swayidle
        networkmanagerapplet
        mesa-demos
        wlogout
      ] else []);
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

  systemd.packages = [ pkgs.pritunl-client ];
  systemd.targets.multi-user.wants = [ "pritunl-client.service" ];

  # disable Ryzen c6 state before sleep
  # https://discourse.nixos.org/t/trouble-with-suspend-resume-on-a-thinkpad-x395-ryzen-7-pro-3700u/4723/45
  systemd.services.before-sleep = {
    description = "Jobs to run before going to sleep";
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.zenstates}/bin/zenstates --c6-disable";
    };
    wantedBy = [ "sleep.target" ];
    before = [ "sleep.target" ];
  };
  systemd.sleep = {
    extraConfig = ''
      HibernateDelaySec=1h
      SuspendState=mem
    '';
  };
  services.logind = {
    # suspend, hibernate, hybrid-sleep, suspend-then-hibernate, lock
    lidSwitch = "suspend-then-hibernate";
    lidSwitchDocked = "ignore";
    lidSwitchExternalPower = "ignore";
  };
  services.power-profiles-daemon.enable = true;

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
