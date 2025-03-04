# vim: set sw=2 et :
{config, lib, pkgs,...}:

{
  home.packages = with pkgs; [
    zsh
    eza
  ];

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
      saveNoDups = true;               # don't save duplicates in hist file
      append = true;                   # append to history, don't truncate it
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
        source ~/etc/zsh/rc/S20_gemini_key
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

}

