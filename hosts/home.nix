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
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    history.size = 100000;
    shellAliases = {
      nix-update = "sudo nixos-rebuild switch --flake /home/${user.name}/nixos/\\#";
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
    initExtra = ''
      if [ -d ~/etc/zsh/rc/ ] ; then
        source ~/etc/zsh/rc/S50_aliases
        source ~/etc/zsh/rc/S50_functions
        source ~/etc/zsh/rc/S60_prompt
      fi
    '';
    envExtra = ''
      if [ -d ~/etc/zsh/rc/ ] ; then
        source ~/etc/zsh/rc/S20_environment
      fi
    '';
  };

  programs.fzf = {
    enable = true;                               # fuzzy finder (ctrl-R)
    enableZshIntegration = true;
  };
  programs.kitty = {
    enable = true;                               # 
    shellIntegration.enableZshIntegration = true;
  };

  programs.carapace.enable = true;               # command line completion generator
  programs.dircolors.enable = true;              # LS_COLORS
  programs.eza.enable = true;                    # ls replacement
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
