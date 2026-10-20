# === General ===

PS1=$'
%F{blue}%{\e[3m%}%~%{\e[0m%}%f '

TMOUT=7200

export XDG_CONFIG_HOME="$HOME/.config"
export EDITOR=nvim

# === Aliases ===

alias ssh="TERM=xterm-256color ssh"  # for tmux

alias python=python3
alias pip=pip3

alias lg=lazygit

function y() {
    local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
    yazi "$@" --cwd-file="$tmp"
    if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
        builtin cd -- "$cwd"
    fi
    rm -f -- "$tmp"
}

# === History ===

HISTSIZE=10000
SAVEHIST=10000

setopt INC_APPEND_HISTORY_TIME
setopt EXTENDED_HISTORY

setopt HIST_IGNORE_DUPS
zshaddhistory() { [[ $1 != (y|lg)$'\n' ]] }

# === Plugins ===

# configure vi mode
ZVM_INIT_MODE=sourcing
ZVM_SYSTEM_CLIPBOARD_ENABLED=true
function zvm_after_lazy_keybindings() {
    zvm_bindkey vicmd 'p' zvm_paste_clipboard_after
    zvm_bindkey vicmd 'P' zvm_paste_clipboard_before
    zvm_bindkey visual 'p' zvm_visual_paste_clipboard
    zvm_bindkey visual 'P' zvm_visual_paste_clipboard
}

zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}' # make completions case-insensitive

eval "$(sheldon source)"

eval "$(zoxide init zsh)"
zsh-defer -c 'eval "$(fzf --zsh)"' # delayed for keybindings
