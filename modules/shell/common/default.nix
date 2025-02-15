# vim: set sw=2 et :
{config, lib, pkgs,...}:

{
  home.packages = with pkgs; [

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
    python313
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

