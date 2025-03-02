# vim: set sw=2 et :

{ config, lib, pkgs, user, inputs, myconf, ... }:

{
  home.stateVersion = "24.11";
  home.username = "${user.name}";
  home.homeDirectory = "/home/${user.name}";

  nixpkgs.config.allowUnfree = true;

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.user}!"
    # '')

    speedtest-cli

    lazydocker
    lazygit
    lazyjournal

    pavucontrol
    pulseaudio
    pulseaudio-ctl

    simple-scan

    git-lfs
    git-fame     # commit stats
    git-gone     # remove stale branches
    #git-radar   # status generator, looks like powerlevel10k already does this
    git-igitt    # better git-graph, TUI

    # -- used by nvim --
    #autotools-language-server
    #awk-language-server
    bashdb
    bash-language-server
    cmake-language-server
    lua-language-server
    vim-language-server
    yaml-language-server
    cppcheck # static analysis for C/C++
    pylint # static analysis for python
    ccls # c/c++ language server (clang)
    nil # language sever for nix
    stylua # lua code formatter
    #nixd # C++ nix language server

    vscode-extensions.vadimcn.vscode-lldb # codelldb for nvim
    vscode-extensions.ms-vscode.cpptools  # cpptools for nvim

    # ttags # tags from tree-sitter

    cargo
    bear
    clang
    clang-tools
    cmake
    # gcc - both gcc and clang want to install bin/ld
    curl
    ftxui
    gdb
    gnumake
    go
    just        # https://github.com/casey/just
    lldb
    ncurses
    ninja
    nodejs_23
    zig

    discord
    slack
    zoom-us
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

    (import ../../modules/terminal/kitty {inherit config lib pkgs inputs myconf;})
    (import ../../modules/terminal/ghostty {inherit config lib pkgs inputs myconf;})

    (import ../../modules/shell/tmux {inherit config lib pkgs inputs myconf;})
    (import ../../modules/shell/zsh {inherit config lib pkgs inputs myconf;})
    (import ../../modules/shell/common {inherit config lib pkgs inputs myconf;})

    (import ../../modules/wm/hyprland {inherit config lib pkgs inputs myconf;})

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

