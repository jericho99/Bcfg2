# .bashrc  BCFG2-IG $Id: .bashrc 52 2010-08-19 17:01:03Z dave $
# Local modifications WILL be lost

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# User specific aliases and functions

alias grep='grep --color=auto'

alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

export PS1='\[\033[01;32m\]\u@\h \[\033[01;34m\]\W \$ \[\033[00m\]'
export HISTCONTROL=ignoredups
export HISTSIZE=10000000
export HISTFILESIZE=10000000
export HISTTIMEFORMAT="%h/%m - %H:%M:%S "
