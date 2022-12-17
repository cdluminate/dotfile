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
export BROWSER=w3m
export FZF_DEFAULT_COMMAND='fdfind --type file --follow'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

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

alias jl="julia --color=yes"
alias ip="ip -c"

abbr -a aug sudo apt upgrade
abbr -a adp sudo apt dist-upgrade
abbr -a off systemctl poweroff
abbr -a sv sudo supervisorctl
abbr -a bt bluetoothctl
abbr -a nb jupyter notebook --no-browser
abbr -a px ps -ux

abbr -a pp pypy3 -m IPython
abbr -a bp bpython3
abbr -a jqt jupyter-qtconsole
abbr -a ap autopep8 -i
abbr -a sshp ssh -o PreferredAuthentications=password
abbr -a wb whalebuilder build debdev
abbr -a cb sudo cowbuilder
abbr -a ao annotate-output

# --- Insane 1-Char abbreviations ---
# history | awk '{print $1}' | sort | uniq -c | sort -n
abbr -a a aria2
abbr -a b btrfs
abbr -a c catimg
abbr -a d pydf
abbr -a e evince
abbr -a f ffmpeg
abbr -a g ag # grep/ack/ag/rg
abbr -a h h5ls
abbr -a i ipython3
abbr -a j julia
#abbr -a k true
#abbr -a l ls -lh
abbr -a m mutt 
abbr -a n ncdu
#abbr -a o true
abbr -a p ipython3 # pdflatex
#abbr -a q true
abbr -a r ranger
#abbr -a s # TK-GUI shortcut, strace
abbr -a t ydcv # translator https://raw.githubusercontent.com/felixonmars/ydcv/master/src/ydcv.py
abbr -a u sudo update-alternatives
abbr -a v vim
#abbr -a w true
abbr -a x xrandr
#abbr -a y true
#abbr -a z # zfs helper

# omf install grc
# fix grc behaviour
alias ls="ls --color"
alias findmnt="grc findmnt"
alias lsblk="grc lsblk"
alias lsmod="grc lsmod"
alias lspci="grc lspci"
alias stat="grc stat"
alias env="grc env"
alias lsof="grc lsof"
alias uptime="grc uptime"
alias ss="grc ss"
alias iptables="grc iptables"
alias id="grc id"
alias df="grc df -h"
alias mtr="mtr -t"
alias dig="grc dig"

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
   fortune-zh
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

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
if test -e /home/lumin/anaconda3/bin/conda
	eval /home/lumin/anaconda3/bin/conda "shell.fish" "hook" $argv | source
end
# <<< conda initialize <<<

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/home/lumin/bin/gsutil/google-cloud-sdk/path.fish.inc' ]; . '/home/lumin/bin/gsutil/google-cloud-sdk/path.fish.inc'; end
