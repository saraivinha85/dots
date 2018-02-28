#
# Executes commands at the start of an interactive session.
#
# Authors:
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#

# Source Prezto.
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

# Customize to your needs...

export EDITOR="vim"
export VISUAL="vim"
export BROWSER="waterfox"
export RANGER_LOAD_DEFAULT_RC=FALSE
export PAGER='less'
export LANG=en_US.UTF-8

# home and key to work
bindkey '\e[1~' beginning-of-line
bindkey '\e[4~' end-of-line
export KEYTIMEOUT=1
bindkey '^P' up-history
bindkey '^N' down-history
bindkey '^?' backward-delete-char
bindkey '^h' backward-delete-char
bindkey '^r' history-incremental-search-backward
bindkey -M vicmd 'k' history-substring-search-up
bindkey -M vicmd 'j' history-substring-search-down

zle -N zle-line-init
zle -N zle-keymap-select
zstyle ":completion:*" rehash true
setopt COMPLETE_ALIASES

# custom command

alias -s mpv='mpv --loop=8'
alias -s webm='mpv --loop=8'
alias rm='rm -If'
alias mkdir='mkdir -p -v'
alias grep='grep --color=auto'
alias du='du -c -h'
alias svim='sudo vim'
alias pacman='sudo pacman'
alias sxiv='sxiv -b -g 645x345'
alias ranger='TERM=xterm-256color ranger'
alias neofetch='clear; neofetch --w3m ~/Imagens/index.jpg --size 40%'

alias ls='ls --group-directories-first --time-style=+"%d.%m.%Y %H:%M" --color=auto -F'
alias ll='ls --group-directories-first --time-style=+"%d.%m.%Y %H:%M" --color=auto -F'
alias la='ls -lha --group-directories-first --time-style=+"%d.%m.%Y %H:%M" --color=auto -F'

alias :q='exit'
alias :x='exit'
alias trans='trans :vi'
alias rsync='rsync -avzhe --progress'

##############################
if which ruby >/dev/null && which gem >/dev/null; then
    PATH="$(ruby -rubygems -e 'puts Gem.user_dir')/bin:$PATH"
fi
##############################
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"
export PATH="$HOME/.rbenv/plugins/ruby-build/bin:$PATH"
##############################
export FSTART="/home/icedreamfeakr/tmpfs"

if [[ $PWD == $HOME ]]; then
  cd $FSTART
fi
