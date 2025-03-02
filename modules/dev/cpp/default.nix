# vim: set sw=2 et :
{config, lib, pkgs,...}:

{
  home.packages = with pkgs; [

    # -- cpp build tools --

    bear
    clang
    clang-tools
    cmake
    # gcc - both gcc and clang want to install bin/ld
    gdb
    gnumake
    lldb
    ninja

    # -- nice dev libs --

    ncurses
    ftxui

    # -- used by nvim LSP --

    #autotools-language-server
    cmake-language-server
    cppcheck # static analysis for C/C++
    ccls # c/c++ language server (clang)
    #nixd # C++ nix language server

    vscode-extensions.vadimcn.vscode-lldb # codelldb for nvim
    vscode-extensions.ms-vscode.cpptools  # cpptools for nvim

    # ttags # tags from tree-sitter

  ];

}

