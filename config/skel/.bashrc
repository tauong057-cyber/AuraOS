# ~/.bashrc for AuraOS

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# History configuration
HISTCONTROL=ignoreboth
HISTSIZE=1000
HISTFILESIZE=2000
shopt -s histappend
shopt -s checkwinsize

# macOS-style clean prompt: user@auraos ~ %
PS1='\[\033[01;32m\]\u@auraos\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '

# Aliases
alias ls='ls --color=auto'
alias ll='ls -lah --color=auto'
alias grep='grep --color=auto'
alias open='xdg-open'
alias cls='clear'
alias finder='thunar'
alias browser='chromium'

# Show Welcome System Info on interactive shell start
if [ -f /etc/auraos/neofetch.conf ]; then
    neofetch --config /etc/auraos/neofetch.conf
fi
