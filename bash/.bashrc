# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth:erasedups

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=5000
HISTFILESIZE=10000
HISTTIMEFORMAT='%F %T  '
shopt -s cmdhist

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
#[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

# prompt helpers (kept lightweight for performance)
__prompt_git_branch() {
    git symbolic-ref --quiet --short HEAD 2>/dev/null || git rev-parse --short HEAD 2>/dev/null
}

__prompt_git_dirty() {
    git diff --quiet --ignore-submodules HEAD 2>/dev/null || echo "*"
}

__prompt_git() {
    local b
    b="$(__prompt_git_branch)"
    if [ -n "$b" ]; then
        printf "(%s%s)" "$b" "$(__prompt_git_dirty)"
    fi
}

__prompt_precmd() {
    __prompt_last_status=$?
    # keep history in sync across sessions
    history -a
    __prompt_render
}

__prompt_render() {
    local s=${__prompt_last_status:-0}
    local status_block

    if [ "$s" -eq 0 ]; then
        status_block='\[\e[1;38;5;82m\]ok\[\e[0m\]'
    else
        status_block="\[\e[1;38;5;196m\]x${s}\[\e[0m\]"
    fi

    # "stunning colorful bash" prompt: vivid, readable, and information rich.
    PS1='\[\e[0m\]${debian_chroot:+($debian_chroot)}\[\e[1;38;5;51m\][\A]\[\e[0m\] \[\e[1;38;5;45m\]\u\[\e[0m\]\[\e[1;38;5;117m\]@\h\[\e[0m\] \[\e[1;38;5;214m\]\w\[\e[0m\] \[\e[1;38;5;177m\]$(__prompt_git)\[\e[0m\] '"${status_block}"$'\n''\[\e[1;38;5;39m\]>>\[\e[0m\] '
}

# capture exit status before prompt rendering (preserves status across PS1 subshells)
if [ -n "$PROMPT_COMMAND" ]; then
    PROMPT_COMMAND="__prompt_precmd; $PROMPT_COMMAND"
else
    PROMPT_COMMAND="__prompt_precmd"
fi

# initial prompt render for fresh shells
__prompt_render
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
#alias ll='ls -l'
#alias la='ls -A'
#alias l='ls -CF'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi
export PATH=~/.npm-global/bin:$PATH
export PATH="$HOME/.local/bin:$PATH"

alias claude='claude --dangerously-skip-permissions'

# better defaults
export LESS='-FRSX'
export LESSHISTFILE=-
export EDITOR=vim
export VISUAL=vim
