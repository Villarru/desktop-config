#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls -l --color=auto'
alias lss='ls -lha --color=auto'
alias mkrepo='/home/khop/Docs/AlgoBash/ejemploBashRepo.sh'
alias hola='/home/khop/Docs/AlgoBash/condi.sh'
alias rm='rm -rf'


PS1='\[\033[01;34m\](\A)\[\033[00;36m\][\u@\h \[\033[00;00m\]\W \[\033[00;36m\]]\[\033[01;36m\]\$\[\033[00;00m\] \e '
export HISTCONTROL=ignoredups

. "$HOME/.cargo/env"
