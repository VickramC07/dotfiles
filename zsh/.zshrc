export PATH="/Users/abhi/Library/Python/3.9/bin:$PATH"

. "$HOME/.local/bin/env"
export PATH="/Library/TeX/texbin:$PATH"


export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

#abbreviation list
source /opt/homebrew/share/zsh-abbr/zsh-abbr.zsh
echo | abbr

#path stuff
echo "Vick's epic terminal zone"
export PATH="/opt/homebrew/bin:$PATH"
export PATH="$PATH:/Users/abhi/bootdev/worldbanc/private/bin"
export PATH="$PATH:/Users/abhi/College/Career/tdf/target/release"
export PATH="$PATH:/Users/abhi/.config/tmux/plugins/.tmuxifier/bin"
export PATH="/opt/homebrew/opt/openjdk/bin:$PATH"
export PATH="$PATH:$HOME/go/bin"
eval "$(tmuxifier init -)"
export EDITOR="nvim"

function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	IFS= read -r -d '' cwd < "$tmp"
	[ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && builtin cd -- "$cwd"
	rm -f -- "$tmp"
}

# Generated for envman. Do not edit.
[ -s "$HOME/.config/envman/load.sh" ] && source "$HOME/.config/envman/load.sh"
