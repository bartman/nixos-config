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
        ssh_symbol = "🌐 ";
        trim_at = ".";
      };
      directory = {
        disabled = false;
        truncate_to_repo = true;
        format = "[ﱮ $path ]($style)";
        style = "fg:#3B76F0";
      };
      nix_shell = {
        disabled = false;
        format = "[$symbol$state( \\($name\\))]($style) ";
        symbol = "❄️  ";
        style = "bold blue";
        impure_msg = "impure";
        pure_msg = "pure";
        unknown_msg = "";
      };
      shell = {
        disabled = false;
        format = "[$indicator]($style) ";
        style = "white bold";
        bash_indicator = "฿";
        cmd_indicator = "𝒸";
        elvish_indicator = "";
        fish_indicator = "";
        ion_indicator = "𝒾";
        nu_indicator = "𝓃";
        powershell_indicator = "𝓅";
        tcsh_indicator = "𝓉";
        unknown_indicator = "";
        xonsh_indicator = "𝓍";
        zsh_indicator = "𝜡";
      };
      git_branch = {
        disabled = false;
        symbol = " ";
        format = "[ $symbol$branch(:$remote_branch) ]($style)";
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
        tag_symbol = " 🏷  ";
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
        format = "([$all_status$ahead_behind]($style) )";
        style = "red bold";
        stashed = "📦";
        ahead = "⬆$count";
        behind = "⬇$count";
	up_to_date = "";
        diverged = "↕";
        conflicted = "🚫";
        deleted = "✘";
        renamed = "»";
        modified = "🖍️"; # 🖊🖋️🖍️
        staged = "+";
        untracked = "?";
        typechanged = "";
        ignore_submodules = false;
      };
      character = {
        success_symbol = "[❯](bold green)";
        vicmd_symbol = "[❮](bold green)";
        error_symbol = "[✗](bold red)";
      };
    };
  };
}
