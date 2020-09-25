# Some helpful environment vars and configs

# Used in .bashrc as well
# Generic default
export GIT_PERS_DIR="$HOME"
export PERL_PERS_DIR="$HOME"

# Make CPAN always select the default option
export PERL_MM_USE_DEFAULT=1

# Perl major version, e.g. 5.30.  Used below for building up some paths, but
# also briefly used in .bashrc a bit.  Could also do -V::version:,
# PERL_VERSION, etc., but all need massaging
export PERL5=$(perl -e'print substr($^V, 1, -2)') # trim leading v and trailing subversion

# Path ------------------------------------------------------------
# Differentiate between home machine and ssh, which will be missing these
# goodies and likely needs different items, local::lib perl, etc.
# toolforge tool account isn't SSH_TTY, but does have the same env variable
if [[ $SSH_TTY || $INSTANCEPROJECT ]]; then
    # This from cpan
    PATH="$HOME/perl5/bin${PATH:+:${PATH}}"; export PATH;
    PERL5LIB="$HOME/perl5/lib/perl5${PERL5LIB:+:${PERL5LIB}}"; export PERL5LIB;
    PERL_LOCAL_LIB_ROOT="$HOME/perl5${PERL_LOCAL_LIB_ROOT:+:${PERL_LOCAL_LIB_ROOT}}"; export PERL_LOCAL_LIB_ROOT;
    PERL_MB_OPT="--install_base \"$HOME/perl5\""; export PERL_MB_OPT;
    PERL_MM_OPT="INSTALL_BASE=/$HOME/perl5"; export PERL_MM_OPT;

    # Don't know if it's old versions (24.5) of emacs or the ssh environment,
    # but having trouble using emacsclient here
    # Worth noting that export doesn't take in aliases
    export EDITOR='emacs '
else
    # Add MacPorts ahead of Homebrew (already present from /etc/paths) and the above
    # Required for getting proper perl and python versions/paths set
    export PATH="/opt/local/bin:/opt/local/sbin:$PATH"

    # Add python execs
    # global; not preferred but just in case
    # With various installations (*cough macports cough*) there are a bunch of
    # symlinks to follow, so this actually gets the full bin path
    # https://stackoverflow.com/q/749711/2521092
    export PATH="$(python -c 'import os;print(os.path.join(os.__file__.split("lib/")[0],"bin","python"))'):$PATH"
    # local; preferable to global
    export PATH="$(python -m site --user-base)/bin:$PATH"

    # Used in .bashrc as well
    export GIT_PERS_DIR="$HOME/Documents/git"
    export PERL_PERS_DIR="$HOME/Documents/perl"

    ## Add perl execs
    # perl should be successfully available from macports/homebrew by now, so
    # get the current version and build up some appropriate paths.  Ideally,
    # this would come before macports and homebrew, but it uses the perl
    # installed there.  Too lazy to have this handle insertion.
    export PERL5=$(perl -e'print substr($^V, 1, -2)') # trim leading v and trailing subversion

    # Perhaps the next time I upgrade perl, I'll wait before installing
    # anything, and set PERL5LIB, etc. to something like the above.  Might be
    # easier (https://formyfriendswithmacs.com/macports.html) but seemsa  pain
    # to actively convert the current setup.
    # Wrapped quotes and trailing space is annoying, but probably more
    # portable not to hardcode these
    perl5_vendorbin=$(perl -V::vendorbin:|tr -d ' '|tr -d \')
    perl5_sitebin=$(perl -V::sitebin:|tr -d ' '|tr -d \')
    export PATH="$perl5_sitebin:$perl5_vendorbin:$PATH"

    if [[ -d "$GIT_PERS_DIR/git-extra-commands@unixorn" ]]; then
	# Add git-extra-commands https://github.com/unixorn/git-extra-commands
	export PATH="$PATH:$GIT_PERS_DIR/git-extra-commands@unixorn/bin"
    fi
    if [[ -d "$GIT_PERS_DIR/tiny-scripts@vitorgalvao" ]]; then
	# Add tiny-scripts stuff https://github.com/vitorgalvao/tiny-scripts
	# Don't need 'em all but better than alias/function-ing just a handful
	export PATH="$PATH:$GIT_PERS_DIR/tiny-scripts@vitorgalvao"
    fi

    # Add unloved perl modules' manpages to the manpath, not as easy as above
    # since perl -V returns man/man1, man/man3, siteman/man1, siteman/man3
    export MANPATH="/opt/local/share/perl$PERL5/siteman:/opt/local/share/perl$PERL5/man:$(manpath)"

    # Worth noting that export doesn't take in aliases
    export EDITOR='emacsclient -cqu '
fi
# Add $HOME's node_modules, if present
# Should probably be higher up, and generic
if [[ `command -v npm` ]]; then
    npm_bin=$(npm bin)
    if [[ -d "$npm_bin" ]]; then
	export PATH="$PATH:$(npm bin)"
    fi
fi
# Add ~/bin ahead of everybody
if [[ -d "$HOME/bin" ]]; then
    export PATH="$HOME/bin:$PATH"
fi
# Modern day, I always want a visual editor
# https://unix.stackexchange.com/q/4859/43935
export VISUAL="$EDITOR "


# Ignore sequential duplicates in history
export HISTCONTROL=erasedups:ignoreboth
# Up history size
export HISTSIZE=5000000
export HISTFILESIZE=$HISTSIZE
# Display timestamp
# export HISTTIMEFORMAT='[%D %H:%M] '
export HISTTIMEFORMAT='[%F %T] '
export HISTIGNORE='ls:la:ll:lal:lla:l1:ltr:lsr:lasr:lt:l:cdl:pwd:clear:exit:logout:pg'


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
# set -o noclobber


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
echo -ne "${Color_Magenta}`uname -sr` up" ; uptime | awk -F'(  |up)' '{print $2$3$4}'
# if [[ ! $SSH_TTY && ! $INSTANCEPROJECT && $(which weather) ]]; then
#     weather ?Qn0		# Uses wttr.in
# fi

# Default designed to always take up same space without leading zero for day,
# meaning dates before the 10th get two spaces, that bugs me
# The system copyright notice, the date and time of the last login, the
# message of the day as well as other information is silenced via .hushlogin
echo -ne "${Color_Red}Local time: ${Color_zOff}" ; date +'%a %b %d %H:%M:%S %Z %Y'
