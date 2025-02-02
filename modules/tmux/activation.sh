#!/bin/sh
set -e

echo "tmux-activation-1"
mkdir -p ~/.config/tmux/plugins/tpm/

echo "tmux-activation-2"
echo "HOME = $HOME"
echo "activation.sh = $0"
test -f $HOME/.config/tmux/plugins/tpm/tpm \
    || git clone https://github.com/tmux-plugins/tpm $HOME/.config/tmux/plugins/tpm/

echo "tmux-activation-3"
exit 0
