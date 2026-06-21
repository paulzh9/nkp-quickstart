#!/bin/bash

addrc(){
    content=$1
    if [ "$(cat ~/.bashrc | grep "$content")" == "" ]; then
        echo "$content" >> ~/.bashrc
    fi
}

addtmux(){
    content=$1
    #check if .tmux.conf exists
    if [ ! -f ~/.tmux.conf ]; then
        touch ~/.tmux.conf
    fi
    if [ "$(cat ~/.tmux.conf | grep "$content")" == "" ]; then
        echo "$content" >> ~/.tmux.conf
    fi
}

addrc 'alias k=kubectl'
addrc 'alias tn="tmux -2 new -s"'
addrc 'alias tl="tmux ls"'
addrc 'alias ta="tmux a -t"'

# fzf-based namespace switcher
if ! grep -q "alias kns=" ~/.bashrc 2>/dev/null; then
cat <<'EOF' >> ~/.bashrc
alias kns='current_ns=$(kubectl config view --minify -o jsonpath="{..namespace}"); kubectl get ns -o name | cut -d/ -f2 | ~/.fzf/bin/fzf --height 40% --reverse --prompt="Namespace> " --header="Current: $current_ns" --header-first --color="header:bright-yellow" --color="pointer:red" --color="marker:green" | xargs kubectl config set-context --current --namespace'
EOF
fi

# fzf-based context switcher
if ! grep -q "alias kx=" ~/.bashrc 2>/dev/null; then
cat <<'EOF' >> ~/.bashrc
alias kx='current_ctx=$(kubectl config current-context); kubectl config get-contexts -o name | ~/.fzf/bin/fzf --height 40% --reverse --prompt="Context> " --header="Current: $current_ctx" --header-first --color="header:bright-yellow" --color="pointer:red" --color="marker:green" | xargs kubectl config use-context'
EOF
fi

source ~/.bashrc

addtmux 'set-option -g default-terminal "screen-256color"'
addtmux 'set-option -g mouse on'