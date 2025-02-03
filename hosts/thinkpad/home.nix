# vim: set sw=2 et :

{ config, lib, pkgs, user, ... }:

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

    bash
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
    netcat
    netcat
    nix-index
    pciutils
    procps
    python313
    socat
    tmux
    tree
    vivid       # LS_COLORS
    usbutils
    wget
    xh          # like curl + jq

    gh          # github
    ripgrep
    unzip
    unrar

    speedtest

    lazydocker
    lazygit
    lazyjournal
    timg       # show images in terminal (kitty)
    termtosvg

    kitty
    kitty-img
    kitty-themes
    pavucontrol
    simple-scan

    git-lfs
    git-fame     # commit stats
    git-gone     # remove stale branches
    #git-radar   # status generator, looks like powerlevel10k already does this
    git-igitt    # better git-graph, TUI

    cargo
    clang
    cmake
    # gcc - both gcc and clang want to install bin/ld
    gdb
    gnumake
    go
    just        # https://github.com/casey/just
    lldb
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
    # intended to start nix-shell with zsh, but does not work
    #NIX_BUILD_SHELL = "zsh";
  };
  
  # Install firefox.
  programs.firefox.enable = true;

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    historySubstringSearch.enable = true;
    enableVteIntegration = true;
    autocd = true;
    defaultKeymap = "viins";
    dotDir = ".config/zsh";
    zprof.enable = false;

    autosuggestion = {
      enable = true;
      highlight = "fg=#888888";                                # "fg=#ff00ff,bg=cyan,bold,underline"
      strategy = [ "match_prev_cmd" "history" "completion" ];
    };

    # disabling built-in highlighting in favour of zsh-f-sy-h plugin
    #syntaxHighlighting = {
    #  enable = true;
    #  styles = {
    #    builtin = "fg=blue,bold";
    #    command = "fg=green,bold";
    #    function = "fg=yellow,bold";
    #  };
    #};

    history = {
      size = 100000;
      save = 1000000;
      expireDuplicatesFirst = true;    # append rather than replace
      ignoreAllDups = false;           # allow historical duplicates
      ignoreDups = true;               # don't store back-to-back duplicates
      ignoreSpace = true;              # don't store lines that start with a space
      share = false;                   # shared between sessions
    };

    shellAliases = {
      l = "eza -al";
    };

    sessionVariables = {
      ZVM_LINE_INIT_MODE = "i";

      # plugin default for zsh-fzf-history-search is...
      #ZSH_FZF_HISTORY_SEARCH_FZF_ARGS = "+s +m -x -e --preview-window=hidden";
      # +s --no-sort
      # +m --no-multi
      # -x --extended (enabled by default)
      # --preview-window=hidden
      ZSH_FZF_HISTORY_SEARCH_FZF_ARGS = "+s +m --preview-window=up,60%,border-rounded,+{2}+3/3,~3";
    };

    initExtraBeforeCompInit = ''
      if [ -d ~/etc/zsh/rc/ ] ; then
        source ~/etc/zsh/rc/S10_zshopts
        source ~/etc/zsh/rc/S11_help
        source ~/etc/zsh/rc/S11_history
        source ~/etc/zsh/rc/S20_environment
        source ~/etc/zsh/rc/S20_openai_key
        source ~/etc/zsh/rc/S20_xai_key
        source ~/etc/zsh/rc/S30_binds
        source ~/etc/zsh/rc/S40_completion
      fi
    '';

    initExtraFirst = ''
      ZVM_LAZY_KEYBINDINGS=true
    '';

    initExtra = ''
      if [ -d ~/etc/zsh/rc/ ] ; then
        source ~/etc/zsh/rc/S50_aliases
        source ~/etc/zsh/rc/S50_functions
        #source ~/etc/zsh/rc/S60_prompt        # using powerlevel10k instead (starship was too slow)
      fi

      # -- vi-mode delayed loading

      # zsh-vi-mode plugin sets ^r to history-incremental-search-backward
      # but we want to use the fzf-history-search plugin instead; good news
      # is that zsh-vi-module provides a mechanism to do this...

      function my_zvm_after_lazy_keybindings() {
        bindkey -M viins '^r' fzf_history_search
      }
      zvm_after_lazy_keybindings_commands+=( my_zvm_after_lazy_keybindings )

      # bad new is that the lazy keybindings dont'g get set until after
      # we enter command mode for the first time.  but there is a fix
      # and that is to inject our binding from the after-init hook.

      function my_zvm_after_init() {
        zvm_bindkey viins '^r' fzf_history_search
      }
      zvm_after_init_commands+=( my_zvm_after_init )

      # -- prompt, powerlevel10k

      source ~/.p10k.zsh

    '';

    envExtra = ''
      if [ -d ~/etc/zsh/rc/ ] ; then
        source ~/etc/zsh/rc/S20_environment
      fi
    '';
    plugins = [
      {
        name = "powerlevel10k";
        src = pkgs.zsh-powerlevel10k;
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      }
      {
        name = "zsh-vi-mode";
        src = pkgs.zsh-vi-mode;
        file = "share/zsh-vi-mode/zsh-vi-mode.plugin.zsh";
      }
      {
        name = "zsh-f-sy-h";
        src = pkgs.zsh-f-sy-h;
        file = "share/zsh/site-functions/F-Sy-H.plugin.zsh";
      }
     #{
     #  name = "zsh-fzf-tab";
     #  src = pkgs.zsh-fzf-tab;
     #  file = "share/fzf-tab/fzf-tab.plugin.zsh";
     #}
      {
        name = "zsh-fzf-history-search";
        src = pkgs.zsh-fzf-history-search;
        file = "share/zsh-fzf-history-search/zsh-fzf-history-search.plugin.zsh";
      }
      {
        name = "forgit";
        src = pkgs.zsh-forgit;
        file = "share/zsh/zsh-forgit/forgit.plugin.zsh";
      }
      {
        # https://github.com/chisui/zsh-nix-shell
        name = "zsh-nix-shell";
        src = pkgs.zsh-nix-shell;
        file = "share/zsh-nix-shell/nix-shell.plugin.zsh";
      }
    ];
  };

  imports = [

    (import ../../modules/tmux {inherit config lib pkgs;})

    # ../../modules/starship-prompt/ascii.nix # prompt generator, slower than powerlevel10k
  ];

  programs.git = {
    enable    = true;
    userName  = "${user.full}";
    userEmail = "${user.email}";
    extraConfig = {
      include = {
        path = "~/etc/gitconfig";
      };
    };
  };

  programs.kitty = {
    enable = true;                               # 
    shellIntegration.enableZshIntegration = true;
    font.name = "Terminus (TTF)";
    font.size = 9.0;
  };

  programs.eza = {                               # ls replacement
    enable = true;
    git = true;
    icons = "auto";
    extraOptions = [
      "--group-directories-first"
    ];
  };

  programs.bat = {
    enable = true;
    config = {
      theme = "TwoDark";
    };
  };

  programs.carapace.enable = true;               # command line completion generator
  programs.dircolors.enable = true;              # LS_COLORS
  programs.navi.enable = true;                   # cheat sheet for cli commands (ctrl-G)
  programs.zoxide.enable = true;                 # cd-replacement
  
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
  } // 
      (if user.hyprland.enable then {
          copyq.enable = true;
          hyprpaper.enable = true;
          swayidle = let
            lockCommand = "${pkgs.swaylock}/bin/swaylock -f -c 000000";
            dpmsCommand = "${pkgs.hyprland}/bin/hyprctl dispatch dpms";
          in {
            enable = true;
            systemdTarget = "graphical-session.target";
            timeouts = [
              {
                timeout = 300;
                command = lockCommand;
              }
              {
                timeout = 600;
                command = "${dpmsCommand} off";
                resumeCommand = "${dpmsCommand} on";
              }
            ];
            events = [
              {
                event = "before-sleep";
                command = lockCommand;
              }
              {
                event = "lock";
                command = lockCommand;
              }
            ];
          };
          dunst.enable = false;
          mako.enable = false;
          swaync = {
            enable = true;
            style = ''
              .notification-row {
                outline: none;
              }

              .notification-row:focus,
              .notification-row:hover {
                background: @noti-bg-focus;
              }

              .notification {
                border-radius: 12px;
                margin: 6px 12px;
                box-shadow: 0 0 0 1px rgba(0, 0, 0, 0.3), 0 1px 3px 1px rgba(0, 0, 0, 0.7),
                  0 2px 6px 2px rgba(0, 0, 0, 0.3);
                padding: 0;
              }
            '';
          };
    } else {});

  systemd.user.startServices = "sd-switch";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}

