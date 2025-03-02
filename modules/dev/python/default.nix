# vim: set sw=2 et :
{config, lib, pkgs,...}:

{
  home.packages = with pkgs; [

    python313

    pylint # static analysis for python

  ];

}

