#!/bin/sh
set -e

mkdir -p ~/.config/tmux/plugins/tpm/

if test -f $HOME/.config/tmux/plugins/tpm/tpm ; then
    echo "tmux tpm already exists"
    exit 0
fi

echo "tmux tpm being cloned..."
git clone --quiet https://github.com/tmux-plugins/tpm $HOME/.config/tmux/plugins/tpm/
echo "... done"
exit 0
