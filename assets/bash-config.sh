#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls -la --color=auto'
alias grep='grep --color=auto'

export NNN_FCOLORS='e1e76699c0d9b06699ff'
export NNN_COLORS='#fcfcfcfc;1234'

PS1='[\u@\h:\W]\$ '