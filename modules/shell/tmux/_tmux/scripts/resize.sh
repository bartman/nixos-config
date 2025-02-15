#!/bin/bash

# enable character input
stty -echo -icanon time 0 min 0

# restore on exit
trap 'stty echo icanon' EXIT

handle_key() {
    case "$1" in
        h) tmux resize-pane -L 1 ;;
        j) tmux resize-pane -D 1 ;;
        k) tmux resize-pane -U 1 ;;
        l) tmux resize-pane -R 1 ;;
        $'\e') exit 0 ;;
        q) exit 0 ;;
    esac
}

while true ; do
    read -rsn1 key
    handle_key "$key"
done
