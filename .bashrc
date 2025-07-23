# Check if ran interactively
[[ $- != *i* ]] && return

# PATH management - only add if not already present
[[ ":$PATH:" != *":$HOME/.local/bin:"* ]] && export PATH="$HOME/.local/bin:$PATH"

# Directory colors
if [[ -x /usr/bin/dircolors ]]; then
	test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
fi

# Editor configuration with fallbacks
if command -v nvim >/dev/null 2>&1; then
	export EDITOR='nvim'
	export VISUAL='nvim'
elif command -v vim >/dev/null 2>&1; then
	export EDITOR='vim'
	export VISUAL='vim'
else
	export EDITOR='nano'
	export VISUAL='nano'
fi

export TERMINAL='foot'
export BROWSER='firefox'
export PAGER='less'

# Less configuration for better viewing
export LESS='-R -i -M -S -x4'
export LESSHISTFILE='-' # Disable less history file

# Global cursor size (useful for TTY as well)
export XCURSOR_SIZE=32

# Bash History - Enhanced
export HISTCONTROL='ignoredups:erasedups:ignorespace'
export HISTSIZE=10000
export HISTFILESIZE=20000
export HISTTIMEFORMAT='%F %T '
shopt -s histappend
shopt -s histverify

# Shell options
shopt -s checkwinsize
shopt -s extglob
shopt -s cdspell  # Correct minor typos in cd commands
shopt -s dirspell # Correct typos in directory names during completion
shopt -s autocd   # Change to directory by just typing its name
shopt -s globstar # Enable ** recursive globbing

# Save and reload history after each command
export PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"

# Source git prompt with error handling
gitPrompt='/usr/share/git/git-prompt.sh'
if [[ -r "$gitPrompt" ]]; then
	source "$gitPrompt"
	export GIT_PS1_SHOWDIRTYSTATE=1
	export GIT_PS1_SHOWUNTRACKEDFILES=1
	export GIT_PS1_SHOWSTASHSTATE=1
	export GIT_PS1_SHOWUPSTREAM='auto'
	PS1='[\[\e[32m\]\u@\h\[\e[0m\] \[\e[34;1m\]\W\[\e[0m\]]\[\e[33m\]$(__git_ps1 " (%s)")\[\e[0m\]\$ '
else
	PS1='[\[\e[32m\]\u@\h\[\e[0m\] \[\e[34;1m\]\W\[\e[0m\]]\$ '
fi

# Enhanced aliases
alias l='ls --color=never'
alias ls='ls --color=auto --group-directories-first'
alias la='ls --color=auto -A --group-directories-first'
alias ll='ls --color=auto -ltrh --group-directories-first'
alias lla='ls --color=auto -ltrAh --group-directories-first'

alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
alias diff='diff --color=auto'

# Safety aliases
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

# Lock screen
alias lck='swaylock -k -f -i ~/Pictures/lockscreen.jpeg'

# Enhanced Wayland session launcher
win() {
	if (( EUID == 0 )); then
		echo -e "\e[31mError: Cannot start Wayland session as root\e[0m"
		return 1
	fi
	
	# Check if already in a graphical session
	if [[ -n "$WAYLAND_DISPLAY" || -n "$DISPLAY" ]]; then
		echo -e "\e[33mWarning: Already in a graphical session\e[0m"
		read -p "Continue anyway? [y/N]: " -n 1 -r
		echo
		[[ ! $REPLY =~ ^[Yy]$ ]] && return 1
	fi
	
	# Set Wayland session environment variables
	export XDG_CURRENT_DESKTOP='sway'
	export XDG_SESSION_DESKTOP='sway'
	export XDG_SESSION_TYPE='wayland'
	export CLUTTER_BACKEND='wayland'
	export SDL_VIDEODRIVER='wayland'
	
	export QT_QPA_PLATFORM='wayland-egl;xcb'
	export QT_WAYLAND_DISABLE_WINDOWDECORATION=1
	export QT_QPA_PLATFORMTHEME='gtk3'
	
	export _JAVA_AWT_WM_NONREPARENTING=1

	export NO_AT_BRIDGE=11
	
	echo 'Launching Wayland session...'
	cd ~ || return 1
	exec dbus-run-session -- sh -c 'pipewire & exec sway'
}

hibernate() {
	sudo zzz -Z && lck
}

# C++ compilation
ass() {
	local name="${1%.*}"
	g++ "$1" -Wall -Wextra ${2:+"$2"} -std=c++17 -O2 -o "${name}.out"
	if [[ $? -ne 0 ]]; then
		echo -e "\e[31mCompilation failed\e[0m"
		return 1
	fi
}

# Run compiled executable
run() {
	local name="${1%.*}"
	if [[ ! -f "${name}.out" ]]; then
		echo -e "\e[31mExecutable '${name}.out' not found\e[0m"
		return 1
	fi
	"./${name}.out"
}

# Compile and run
cnr() {
	ass "$1" "$2" && run "$1"
}

gen() {
	for name in "$@"; do
		local ext="${name##*.}"
		if [[ -f "$name" ]]; then
			echo -e "\e[33mWarning: '$name' already exists\e[0m"
			read -p "Overwrite? [y/N]: " -n 1 -r
			echo
			[[ ! $REPLY =~ ^[Yy]$ ]] && continue
		fi
		cp -f "$HOME/Templates/main.$ext" "./$name"
		if [[ $? -ne 0 ]]; then
			echo -e "\e[31mTemplate for '$ext' extension not found\e[0m"
		fi
	done
}

# Find and kill process by name
psgrep() {
	pgrep -ia "$@"
}

pskill() {
	local pid
	pid=$(ps -ef | sed 1d | fzf -m | awk '{print $2}')
	if [[ -n "$pid" ]]; then
		echo "$pid" | xargs kill -"${1:-9}"
	fi
}
