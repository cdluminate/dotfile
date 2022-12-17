# Initialize new style completion
autoload -Uz compinit
compinit
zstyle ':completion:*::::' completer _expand _complete _ignored _approximate

# Initialize prompt
PROMPT="%F{cyan}%~%f %F{red}❯%F{yellow}❯%F{green}❯%F{cyan}❯%f%b "
RPROMPT="%B%(?..%F{red}[%?]%f )%F{magenta}%*%f"

# Detect chroot environment
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
	debian_chroot=$(cat /etc/debian_chroot)
	PROMPT="${debian_chroot:+($debian_chroot)}:$PROMPT"
fi

# Adjust Zsh behaviour
setopt autocd autolist
setopt inc_append_history share_history
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.zsh_history

# Aliases
alias ls='ls --color'
alias jl='julia'

# Load utilities
#source /etc/grc.zsh
source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/share/doc/fzf/examples/key-bindings.zsh

# Environment variables
export PATH=$HOME/bin:$HOME/.local/bin:$HOME/anaconda3/bin:/usr/lib/ccache:$PATH
