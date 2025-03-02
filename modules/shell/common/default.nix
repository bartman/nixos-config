# vim: set sw=2 et :
{config, lib, pkgs,...}:

{
  home.packages = with pkgs; [

    # nix utilities

    nh                   # https://github.com/viperML/nh
    nix-output-monitor   # nix-build |& nom


    # shell tools

    bash
    difftastic
    fd
    #fh                  # https://docs.determinate.systems/flakehub/cli (needs to read up on security)
    file
    findutils
    fzf
    gh                  # github
    git
    gnumake
    iftop
    jq
    killall
    netcat
    netcat
    pciutils
    powertop
    procps
    ripgrep
    socat
    tmux
    tree
    unicode-paracode
    unrar
    unzip
    usbutils
    vivid               # LS_COLORS
    wget
    xh                  # like curl + jq

  ];

  programs.nh = {
    enable = true;
    clean.enable = false; # conflicts with nix.gc.automatic
    # clean.extraArgs = "--keep-since 7d --keep 5";
    # flake = ...clean
  };

  programs.bash.enable = true;

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

  programs.btop = {
    enable = true;
    settings = {
      color_theme = "gruvbox_dark_v2";
      vim_keys = true;
    };
  };


}

