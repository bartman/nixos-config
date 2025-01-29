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
    #   echo "Hello, ${config.home.username}!"
    # '')

    btop
    gh
    ripgrep
    just        # https://github.com/casey/just

  ];

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
    EDITOR = "nvim";
    VISUAL = "nvim";
  };

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
      ZSH_FZF_HISTORY_SEARCH_FZF_ARGS = "--preview-window=up,60%,border-rounded,+{2}+3/3,~3";
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
        #source ~/etc/zsh/rc/S60_prompt        # using starship instead
      fi

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
    '';

    envExtra = ''
      if [ -d ~/etc/zsh/rc/ ] ; then
        source ~/etc/zsh/rc/S20_environment
      fi
    '';
    plugins = [
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
      {
        name = "zsh-fzf-tab";
        src = pkgs.zsh-fzf-tab;
        file = "share/fzf-tab/fzf-tab.plugin.zsh";
      }
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

  imports = [ ../modules/starship-prompt.nix ];

  programs.tmux = {
    enable = true;
    extraConfig = ''
      #source ~/etc/tmux.conf
    '';
  };

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
  };
  programs.eza = {                               # ls replacement
    enable = true;
    git = true;
    icons = "auto";
    extraOptions = [
      "--group-directories-first"
    ];
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

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
