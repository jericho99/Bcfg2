# .bashrc BCFG2-IG $Id: .bashrc 43 2010-08-19 14:17:21Z dave $
# User specific aliases and functions

alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias vi='vim'

# Source global definitions
if [ -f /etc/bashrc ]; then
        . /etc/bashrc
fi


alias grep='grep --color=auto'

export PS1='\[\033[01;31m\]\u@\h \[\033[01;34m\]\W \$ \[\033[00m\]'
export HISTCONTROL=ignoredups
export HISTSIZE=10000000
export HISTFILESIZE=10000000
export HISTFILE=/root/.bash_hist-$(who am i | awk '{print $1}';exit)
export HISTTIMEFORMAT="%h/%m - %H:%M:%S "

