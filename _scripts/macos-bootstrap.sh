
# --------------------------------------------------
# | install stuff with brew
# --------------------------------------------------
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

# --------------------------------------------------
# | make HOME and END jump to beginning/end of line
# --------------------------------------------------
mkdir ~/Library/KeyBindings/ && cat >> ~/Library/KeyBindings/DefaultKeyBinding.dict <<'EOF'
{
    "\UF729"  = moveToBeginningOfLine:; // home
    "\UF72B"  = moveToEndOfLine:; // end
    "$\UF729" = moveToBeginningOfLineAndModifySelection:; // shift-home
    "$\UF72B" = moveToEndOfLineAndModifySelection:; // shift-end
}
EOF
