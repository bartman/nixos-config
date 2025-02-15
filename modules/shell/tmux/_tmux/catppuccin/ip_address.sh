# If this module depends on an external Tmux plugin, say so in a comment.
# E.g.: Requires https://github.com/aaronpowell/tmux-weather

show_ip_address() { # This function name must match the module name!
  local index addr icon color text module

  index=$1 # This variable is used internally by the module loader in order to know the position of this module

  addr="$(ip r g 8.8.8.8 | sed -rne 's/ uid.*//' -e 's/.*src //p' | xargs)"

  icon="$(  get_tmux_option "@catppuccin_ip_address_icon"  "🖧"           )"
  color="$( get_tmux_option "@catppuccin_ip_address_color" "$thm_orange" )"
  text="$(  get_tmux_option "@catppuccin_ip_address_text"  "$addr"       )"

  module=$( build_status_module "$index" "$icon" "$color" "$text" )

  echo "$module"
}
