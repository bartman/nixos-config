# vim: set sw=2 et :
{config, lib, pkgs,...}:

{
  home.packages = with pkgs; [

    # -- non-cpp build tools --

    cargo
    curl
    go
    just        # https://github.com/casey/just
    nodejs_23
    zig

    # -- used by nvim LSP --

    #awk-language-server
    bashdb
    bash-language-server
    lua-language-server
    vim-language-server
    yaml-language-server
    pylint # static analysis for python
    nil # language sever for nix
    stylua # lua code formatter
    #nixd # C++ nix language server

    # ttags # tags from tree-sitter

  ];

}

