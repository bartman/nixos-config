# vim: set sw=2 et :

{ config, lib, pkgs, user, inputs, myconf, ... }:

{
  home.stateVersion = "24.11";
  home.username = "${user.name}";
  home.homeDirectory = "/home/${user.name}";

  targets.genericLinux.enable = true;   # make home manager work better on non-NixOS systems
  nixpkgs.config.allowUnfree = true;

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.user}!"
    # '')

    speedtest-cli

    mfcl3770cdwlpr
    brscan4
    sof-firmware
    pritunl-client

    ollama
    # ollama-cuda          # TOOD: need to integrate into systemd script
    # open-webui         # TODO: need to figure out how to start it

    zenstates # https://github.com/r4m0n/ZenStates-Linux

    firefox
  ];

  xsession.enable = false;

  qt = {
    enable = true;
    platformTheme.name = "gtk";
    style.name = "adwaita-dark";
    style.package = pkgs.adwaita-qt;
  };

  gtk = {
    enable = true;
    cursorTheme = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Ice";
    };
    theme = {
      name = "Dracula";
      package = pkgs.dracula-theme;
      #name = "adw-gtk3";
      #package = pkgs.adw-gtk3;
    };
    iconTheme = {
      name = "gruvbox-dark-gtk";
      package = pkgs.gruvbox-dark-gtk;
      #name = "papirus-Dark";
      #package = pkgs.papirus-icon-theme;
    };
    font = {
      name = "FiraCode Nerd Font Mono Medium";
    };
  };


  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  home.sessionVariables = {
    TERMINAL = "kitty";
    EDITOR = "nvim";
    VISUAL = "nvim";
    # intended to start nix-shell with zsh, but does not work
    #NIX_BUILD_SHELL = "zsh";
  };

  # Install firefox.
  programs.firefox.enable = true;

  imports = [

    (import ../../modules/terminal/kitty {inherit config lib pkgs user inputs myconf;})
    (import ../../modules/terminal/ghostty {inherit config lib pkgs user inputs myconf;})

    (import ../../modules/shell/tmux {inherit config lib pkgs user inputs myconf;})
    (import ../../modules/shell/zsh {inherit config lib pkgs user inputs myconf;})
    (import ../../modules/shell/common {inherit config lib pkgs user inputs myconf;})

    (import ../../modules/dev/cpp {inherit config lib pkgs user inputs myconf;})
    (import ../../modules/dev/git {inherit config lib pkgs user inputs myconf;})
    (import ../../modules/dev/python {inherit config lib pkgs user inputs myconf;})
    (import ../../modules/dev/other {inherit config lib pkgs user inputs myconf;})

    (import ../../modules/wm/hyprland {inherit config lib pkgs user inputs myconf;})

    # ../../modules/starship-prompt/ascii.nix # prompt generator, slower than powerlevel10k
  ];

  programs.neovim.enable = true;
  programs.neovim.vimAlias = true;
  programs.neovim.viAlias = true;

  programs.ssh = {
    enable = true;
    compression = true;
    controlMaster = "auto";
    addKeysToAgent = "yes";

    matchBlocks = {
      untether = {
        host = "*.untetherai.com";
        user = "bartt";
        extraOptions = {
          ControlMaster = "auto";
          TCPKeepAlive = "yes";
          SetEnv = "TERM=xterm-256color";
        };
      };
    };
  };

  services = {
    ssh-agent.enable = true;
    gpg-agent = {
      enable = true;
      defaultCacheTtl = 1800;
      enableSshSupport = false;
    };
  };

  systemd.user.startServices = "sd-switch";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}

