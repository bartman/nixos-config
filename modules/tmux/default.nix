# vim: set sw=2 et :
{config, lib, pkgs,...}:

{
  programs.tmux = {
    enable = true;
    extraConfig = builtins.readFile ./_tmux.conf;
  };

  home.file.".config/tmux" = {
    source = ./_tmux;
    recursive = true;
  };

  # clone https://git::@github.com/tmux-plugins/tpm to ~/.config/tmux/plugins/tpm/

  home.activation.tmuxActivation = lib.hm.dag.entryAfter ["writeBoundary"] ''
    run "${builtins.toPath ./activation.sh}"
  '';

}
