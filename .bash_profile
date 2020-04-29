# Path ------------------------------------------------------------
# add MacPorts ahead of Homebrew (already present from /etc/paths)
export PATH="/opt/local/bin:/opt/local/sbin:$PATH"
# Add python execs, not sure if this is the best but so be it
export PATH="/opt/local/Library/Frameworks/Python.framework/Versions/Current/bin:$PATH"
# Add perl execs; again, not sure if this is best
export PATH="/opt/local/libexec/perl5.24/sitebin:$PATH"
# add ~/bin
export PATH="$HOME/bin:$PATH"
# add git-extra-commands https://github.com/unixorn/git-extra-commands
export PATH="$PATH:$HOME/Documents/git/git-extra-commands@unixorn/bin"
# add tiny-scripts stuff https://github.com/vitorgalvao/tiny-scripts
# Don't need 'em all but better than alias/function-ing just a handful
export PATH="$PATH:$HOME/Documents/git/tiny-scripts@vitorgalvao"
# Add $HOME's node_modules
export PATH="$PATH:$(npm bin)"

# Add unloved perl modules
export MANPATH="/opt/local/share/perl5.24/siteman:/opt/local/share/perl5.24/man:$MANPATH"

# emacs > vim
export EDITOR="emacs"
export VISUAL="emacs"
# Ignore sequential duplicates in history
export HISTCONTROL=erasedups:ignoreboth
# Up history size
export HISTSIZE=5000000
export HISTFILESIZE=$HISTSIZE
# Display timestamp
# export HISTTIMEFORMAT='[%D %H:%M] '
export HISTTIMEFORMAT='[%F %T] '
export HISTIGNORE='ls:la:ll:lal:lla:l1:ltr:lsr:lasr:lt:l:cdl:pwd:* --help:* -h:btc:clear:exit:logout:history*:h:pg'


# Append all history to same file, don't overwrite
# Still doesn't get it perfectly unified across logins
shopt -s histappend
# Attempt to save all lines of multi-line commands in one line
shopt -s cmdhist
# Autofix transposed/missing/extra characters in cd.  Not too useful but hey
shopt -s cdspell
# Try to correct directory names when tab-completing
shopt -s dirspell
# Type 'dir' instead of 'cd dir'
shopt -s autocd
# Use ** for recursive glob
shopt -s globstar
# Check window size after each command, update values of lines/columns
shopt -s checkwinsize
# Case-insensitive globbing (used in pathname expansion)
shopt -s nocaseglob
# Do not autocomplete when accidentally pressing Tab on an empty line - takes
# forever and yields "Display all 15 gazillion possibilites?"
shopt -s no_empty_cmd_completion
# If a command contains an invalid history operation, let me correct it
shopt -s histreedit
# Prevent file overwrite on stdout redirection
set -o noclobber


# Load in .bashrc -------------------------------------------------
source ~/.bashrc

# Welcome Messsage --------------------------------------------------
echo -ne "Welcome to${Color_Green}" `hostname -s` "${Color_zOff}on"
if [[ $OSTYPE == darwin* ]]; then
    echo -ne "${Color_Green}" `sw_vers -productName` `sw_vers -productVersion`
elif [[ $OSTYPE == linux* ]]; then
    echo -ne "${Color_Green}" `uname -o`
else
    echo -ne "${Color_Green}" `uname -a`
fi
echo -e "${Color_zOff} ("`uname -m`")"
if [[ `command -v fortune` && $UID != '0' && $- == *i* && $TERM != 'dumb' ]]; then
    echo -ne "${Color_White}"; fortune -s; echo -ne "${Color_zOff}" # only short ones
fi
echo -ne "${Color_Magenta}`uname -sr` up" ; uptime | awk -F'(  |up)' '{print $3" "$4}'
weather ?Qn0			# Uses wttr.in

# Default designed to always take up same space without leading zero for day,
# meaning dates before the 10th get two spaces, that bugs me
# The system copyright notice, the date and time of the last login, the
# message of the day as well as other information is silenced via .hushlogin
echo -ne "${Color_Red}Local time: ${Color_zOff}" ; date +'%a %b %d %H:%M:%S %Z %Y'

test -e "${HOME}/.iterm2_shell_integration.bash" && source "${HOME}/.iterm2_shell_integration.bash"

