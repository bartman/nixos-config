# vim: set sw=2 et

{ config, lib, pkgs, user, ... }:

{
  home.stateVersion = "24.11";
  home.username = "${user.name}";
  home.homeDirectory = "/home/${user.name}";

  nixpkgs.config.allowUnfree = true;

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.user}!"
    # '')

    btop
    clang
    cmake
    discord
    dunst
    # no gcc - both gcc and clang want to install bin/ld
    feh
    libnotify # for dunst
    gdb
    gh
    kitty
    kitty-img
    kitty-themes
    lldb
    ripgrep
    slack
    unzip
    unrar
    zoom-us
    zoxide

  ];

  xsession = {
    enable = true;
    numlock.enable = false;
  };
  home.pointerCursor = {
    name = "Dracula-cursors";
    package = pkgs.dracula-theme;
    size = 16;
  };

  gtk = {
    enable = true;
    theme = {
      name = "Dracula";
      package = pkgs.dracula-theme;
    };
    iconTheme = {
      name = "papirus-Dark";
      package = pkgs.papirus-icon-theme;
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

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/bart/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    TERMINAL = "kitty";
    EDITOR = "nvim";
    VISUAL = "nvim";
  };
  
  programs.neovim.enable = true;
  programs.neovim.vimAlias = true;
  programs.neovim.viAlias = true;

  programs.btop = {
    enable = true;
    settings = {
      color_theme = "gruvbox_dark_v2";
      vim_keys = true;
    };
  };

  # Install firefox.
  programs.firefox.enable = true;
}

