# vim: set sw=2 et :
{config, lib, pkgs,...}:

{
  home.packages = with pkgs; [

    git-lfs
    git-fame     # commit stats
    git-gone     # remove stale branches
    #git-radar   # status generator, looks like powerlevel10k already does this
    git-igitt    # better git-graph, TUI

  ];

  programs.git = {
    enable    = true;
    userName  = "${user.full}";
    userEmail = "${user.email}";
    extraConfig = {
      column.ui = "auto";
      branch.sort = "-committerdate";
      tag.sort = "version:refname";
      init.defaultBranch = "master";
      diff.algorithm = "histogram";
      diff.colorMoved = "plain";
      diff.mnemonicPrefix = true;
      diff.renames = true;
      push.default = "simple";
      push.autoSetupRemote = true;
      push.followTags = true;
      fetch.prune = true;
      fetch.pruneTags = true;
      fetch.all = true;

      help.autocorrect = "prompt";
      commit.verbose = true;
      rerere.enabled = true;
      rerere.autoupdate = true;
      core.excludesfile = "~/.gitignore";
      rebase.autoSquash = true;
      rebase.autoStash = true;
      rebase.updateRefs = false;

      include = {
        path = "~/etc/gitconfig";
      };
    };
  };


}

