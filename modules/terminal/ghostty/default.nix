# vim: set sw=2 et :
{config, lib, pkgs,...}:

{
  home.packages = with pkgs; [

    ghostty

    termtosvg
    timg       # show images in terminal (ghostty protocol)
  ];

  programs.ghostty = {
    enable = true;
    enableZshIntegration = true;
    installBatSyntax = true;
    settings = {
      font-family = "Terminus (TTF)";
      font-synthetic-style = "bold,italic,bold-italic";
      font-size = 9.0;
      adjust-cell-height = -2;
      grapheme-width-method = "legacy";
      freetype-load-flags = "no-hinting,no-force-autohint,monochrome,no-autohint";

      theme = "catppuccin-mocha";
      background = "#000000";
      foreground = "#FFFFFF";
      cursor-opacity = 1;
      cursor-style = "block";

      palette = [
        "0=#000000"
        "1=#cc0403"
        "2=#19cb00"
        "3=#cecb00"
        "4=#0d73cc"
        "5=#cb1ed1"
        "6=#0dcdcd"
        "7=#dddddd"
        "8=#767676"
        "9=#f2201f"
        "10=#23fd00"
        "11=#fffd00"
        "12=#1a8fff"
        "13=#fd28ff"
        "14=#14ffff"
        "15=#ffffff"
      ];

      window-theme = "ghostty";
      #gtk-custom-css = "~/.config/ghostty/gtk.css";
      window-decoration = false;
      window-padding-x = 2;
      window-padding-y = 2;
      gtk-titlebar-hide-when-maximized = true;
      gtk-single-instance = true;

      shell-integration = "zsh";

      keybind = [
        "ctrl+comma=open_config"
        "ctrl+alt+up=goto_split:top"
        "ctrl+page_down=next_tab"
        "ctrl+shift+v=paste_from_clipboard"
        "shift+insert=paste_from_selection"
        "ctrl+shift+a=select_all"
        "shift+up=adjust_selection:up"
        "super+ctrl+right_bracket=goto_split:next"
        "ctrl+equal=increase_font_size:1"
        "ctrl+shift+o=new_split:right"
        "ctrl+shift+c=copy_to_clipboard"
        "ctrl+shift+q=quit"
        "ctrl+shift+n=new_window"
        "ctrl+shift+page_down=jump_to_prompt:1"
        "ctrl+shift+comma=reload_config"
        "ctrl+minus=decrease_font_size:1"
        "shift+left=adjust_selection:left"
        "super+ctrl+shift+up=resize_split:up,10"
        "shift+page_up=scroll_page_up"
        "ctrl+alt+shift+j=write_scrollback_file:open"
        "ctrl+shift+left=previous_tab"
        "ctrl+shift+w=close_surface"
        "super+ctrl+shift+equal=equalize_splits"
        "shift+end=scroll_to_bottom"
        "ctrl+zero=reset_font_size"
        "ctrl+shift+j=write_scrollback_file:paste"
        "ctrl+enter=toggle_fullscreen"
        "ctrl+page_up=previous_tab"
        "shift+right=adjust_selection:right"
        "ctrl+tab=next_tab"
        "ctrl+alt+left=goto_split:left"
        "shift+page_down=scroll_page_down"
        "ctrl+shift+right=next_tab"
        "ctrl+shift+page_up=jump_to_prompt:-1"
        "ctrl+shift+t=new_tab"
        "shift+down=adjust_selection:down"
        "super+ctrl+shift+left=resize_split:left,10"
        "ctrl+shift+tab=previous_tab"
        "ctrl+alt+down=goto_split:bottom"
        "super+ctrl+shift+down=resize_split:down,10"
        "super+ctrl+shift+right=resize_split:right,10"
        "ctrl+plus=increase_font_size:1"
        "ctrl+shift+e=new_split:down"
        "ctrl+alt+right=goto_split:right"
        "alt+f4=close_window"
        "ctrl+shift+enter=toggle_split_zoom"
        "shift+home=scroll_to_top"
        "super+ctrl+left_bracket=goto_split:previous"
        "ctrl+shift+i=inspector:toggle"

        "ctrl+shift+one=goto_tab:1"
        "ctrl+shift+two=goto_tab:2"
        "ctrl+shift+three=goto_tab:3"
        "ctrl+shift+four=goto_tab:4"
        "ctrl+shift+five=goto_tab:5"
        "ctrl+shift+six=goto_tab:6"
        "ctrl+shift+seven=goto_tab:7"
        "ctrl+shift+eight=goto_tab:8"
        "ctrl+shift+nine=last_tab"
      ];
    };
  };


}
