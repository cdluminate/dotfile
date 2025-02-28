                                                                # - Variables -
export GIT_EDITOR=vim
#export _JAVA_AWT_WM_NONREPARENTING=1
set PATH $HOME/bin $HOME/.cargo/bin $HOME/.linuxbrew/bin $HOME/.local/bin $HOME/anaconda3/bin /usr/lib/ccache $PATH
export LESSOPEN="| /usr/share/source-highlight/src-hilite-lesspipe.sh %s"       
export LESS=' -R '             
export NINJA_STATUS='[38;5;162m[%p %f/%t][0;m '
export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS=@im=fcitx
#export BROWSER=sensible-browser
export FZF_DEFAULT_COMMAND='fdfind --type file --follow'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export TERM=xterm-256color

                                                                  # - Helpers -
function aup
   sudo apt update
   sudo apt list --upgradable
end

function gpa
   git push $argv --all
   git push $argv --tags
end

function ips
	ip -s -c -h a
end

alias ip="ip -c"

abbr -a aug sudo apt upgrade
abbr -a bt bluetoothctl
abbr -a px ps -ux

abbr -a sshp ssh -o PreferredAuthentications=password

# --- Insane 1-Char abbreviations ---
# history | awk '{print $1}' | sort | uniq -c | sort -n

# omf install grc
source /etc/grc.fish
alias ls="ls --color"
alias dg="debgpt"

                                                         # - debian packaging - 
function dquilt
	quilt --quiltrc=$HOME/.quiltrc-dpkg $argv
end

export DPKG_COLORS=always
export DEBEMAIL="lumin@debian.org"
export DEBFULLNAME="Mo Zhou"
export DEBUGINFOD_URLS="https://debuginfod.debian.net"
export QUILT_SERIES=debian/patches/series
export QUILT_PATCHES=debian/patches

                                                                # - Greetings -
# Don't break Rsync, Scp or something alike. You can use this script to
# test whether fish is writting something to terminal.
# foo.fish:
# | echo extra stuff
# Then $ fish foo.fish
#
# https://github.com/fish-shell/fish-shell/issues/3473#issuecomment-254599357
# https://superuser.com/questions/679498/specifying-an-alternate-shell-with-rsync
if status --is-interactive
   grc uptime
end

# Automatically synced history, might cause a bit slow down
# https://github.com/fish-shell/fish-shell/issues/825#issuecomment-226646287
function sync_history --on-event fish_preexec
    history --save
    history --merge
end

function fish_right_prompt -d "write out the right prompt"
	date '+%H:%M'
end

# Disable the "welcome to fish ..." message.
set -U fish_greeting ""

fzf --fish | source
