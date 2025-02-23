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

    mfcl3770cdwlpr
    brscan4
    sof-firmware
    pritunl-client

    zenstates # https://github.com/r4m0n/ZenStates-Linux

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

  programs.bash.enable = true;

  imports = [

    (import ../../modules/terminal/kitty {inherit config lib pkgs inputs myconf;})
    (import ../../modules/terminal/ghostty {inherit config lib pkgs inputs myconf;})

    (import ../../modules/shell/tmux {inherit config lib pkgs inputs myconf;})
    (import ../../modules/shell/zsh {inherit config lib pkgs inputs myconf;})
    (import ../../modules/shell/common {inherit config lib pkgs inputs myconf;})

    (import ../../modules/wm/hyprland {inherit config lib pkgs inputs myconf;})

    # ../../modules/starship-prompt/ascii.nix # prompt generator, slower than powerlevel10k
  ];

  programs.git = {
    enable    = true;
    userName  = "${user.full}";
    userEmail = "${user.email}";
    extraConfig = {
      column.ui = "auto";
      branch.sort = "-committerdate";
      tag.sort = "version:refname";
      init.defaultBranch = "master";
      diff.algorithm = "histogram";
      diff.colorMoved = "plain";
      diff.mnemonicPrefix = true;
      diff.renames = true;
      push.default = "simple";
      push.autoSetupRemote = true;
      push.followTags = true;
      fetch.prune = true;
      fetch.pruneTags = true;
      fetch.all = true;

      help.autocorrect = "prompt";
      commit.verbose = true;
      rerere.enabled = true;
      rerere.autoupdate = true;
      core.excludesfile = "~/.gitignore";
      rebase.autoSquash = true;
      rebase.autoStash = true;
      rebase.updateRefs = false;

      include = {
        path = "~/etc/gitconfig";
      };
    };
  };

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

