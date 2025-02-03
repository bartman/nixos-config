# vim: set sw=2 et :
{
  programs.starship = {                         # prompt theme engine
    enable = true;
    settings = {
      add_newline = false;
      command_timeout = 1300;
      scan_timeout = 50;
      format= ''$username$hostname$directory$character'';
      right_format= ''$nix_shell$shell$git_branch$git_commit$git_state$git_status'';
      fill = {
        symbol = " ";
      };
      line_break = {
        disabled = true;
      };
      username = {
        disabled = false;
        format = "[$user]($style) ";
        style_root = "red bold";
        style_user = "yellow bold";
      };
      hostname = {
        disabled = false;
        format = "[$ssh_symbol$hostname]($style) ";
        style = "green dimmed bold";
        ssh_only = true;
        ssh_symbol = "\\$ "; # unicode "🌐 ";
        trim_at = ".";
      };
      directory = {
        disabled = false;
        truncate_to_repo = true;
        format = "[> $path ]($style)"; # unicode "[ﱮ $path ]($style)";
        style = "fg:#3B76F0";
      };
      nix_shell = {
        disabled = false;
        format = "[$symbol$state( \\($name\\))]($style) ";
        symbol = "* "; # unicode "❄️  ";
        style = "bold blue";
        impure_msg = "impure";
        pure_msg = "pure";
        unknown_msg = "";
      };
      shell = {
        disabled = false;
        format = "[$indicator](bg:white fg:black) ";
        bash_indicator       = "b"; # unicode "฿";
        cmd_indicator        = "c"; # unicode "𝒸";
        elvish_indicator     = "e"; # unicode "";
        fish_indicator       = "f"; # unicode "";
        ion_indicator        = "i"; # unicode "𝒾";
        nu_indicator         = "n"; # unicode "𝓃";
        powershell_indicator = "p"; # unicode "𝓅";
        tcsh_indicator       = "t"; # unicode "𝓉";
        unknown_indicator    = "u"; # unicode "";
        xonsh_indicator      = "x"; # unicode "𝓍";
        zsh_indicator        = "z"; # unicode "𝜡";
      };
      git_branch = {
        disabled = false;
        symbol = "@"; # unicode " ";
        format = "[$symbol$branch(:$remote_branch) ]($style)";
        style = "fg:#FCF392";
      };
      git_metrics = {
        disabled = false;
        format = "([+$added]($added_style) )([-$deleted]($deleted_style) )";
        ignore_submodules = false;
        added_style = "bold green";
        deleted_style = "bold red";
        only_nonzero_diffs = true;
      };
      git_commit = {
        disabled = false;
        format = "[\\($hash$tag\\)]($style) ";
        style = "green bold";
        commit_hash_length = 7;
        only_detached = true;
        tag_symbol = "*"; # unicode" 🏷  ";
        tag_disabled = true;
        tag_max_candidates = 0;
      };
      git_state = {
        disabled = false;
        format = "\\([$state( $progress_current/$progress_total)]($style)\\) ";
        style = "bold yellow";
        rebase = "REBASING";
        merge = "MERGING";
        revert = "REVERTING";
        cherry_pick = "CHERRY-PICKING";
        bisect = "BISECTING";
        am = "AM";
        am_or_rebase = "AM/REBASE";
      };
      git_status = {
        disabled = false;
        format = "([$all_status$ahead_behind]($style) )";
        style = "bg:white fg:black";
        stashed     = "#";              # unicode "📦";
        ahead       = ">$count";        # unicode "⬆$count";
        behind      = "<$count";        # unicode "⬇$count";
        up_to_date  = "";               # unicode "";
        diverged    = "~";              # unicode "↕";
        conflicted  = "!";              # unicode "🚫";
        deleted     = "x";              # unicode "✘";
        renamed     = "r";              # unicode "»";
        modified    = "m";              # unicode "🖍️"; # 🖊🖋️🖍️
        staged      = "+";              # unicode "+";
        untracked   = "?";              # unicode "?";
        typechanged = "";               # unicode "";
        ignore_submodules = false;
      };
      character = {
        success_symbol = "[>](bold green)";
        vicmd_symbol = "[<](bold yellow)";
        error_symbol = "[x](bold red)";
      };
    };
  };
}
