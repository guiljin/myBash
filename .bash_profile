# .bash_profile

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
        . ~/.bashrc
fi

# User specific environment and startup programs


export PS1="\[\e[36;1m\][\u@\h \W]\$\[\e[0m\]"
export HISTSIZE=10000
export SVN_EDITOR=vim
export GREP_OPTIONS="--color=auto"
export http_proxy=http://10.144.1.10:8080/
export https_proxy=https://10.144.1.10:8080/
export ftp_proxy=ftp://10.144.1.10:8080/
alias cdh="cd /ephemeral/CBTS_CI"


g() {
    grep -Ir \
         --exclude-dir=.git \
         --exclude-dir='build*' \
         --include='*.bb*' \
         --include='*.inc*' \
         --include='*.conf*' \
         --include='*.py*' \
         "$@"
}
