declare -a PACKAGES=(
    bash
    bash-completion
    coreutils
    findutils
    gawk
    gnu-getopt
    gnu-indent
    gnu-sed
    gnu-tar
    gnu-which
    gnutls
    grep
    htop
    make
    tmux
)
brew install ${PACKAGES[*]}

echo To switch to the new bash:
echo "sudo echo /usr/local/bin/bash >> /etc/shells"
echo "chsh -s /usr/local/bin/bash"
