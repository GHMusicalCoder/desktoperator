# Personal Zsh configuration file. It is strongly recommended to keep all
# shell customization and configuration (including exported environment
# variables such as PATH) in this file or in files sourced from it.
#
# Documentation: https://github.com/romkatv/zsh4humans/blob/v5/README.md.

#####=== z4h Core Config

# Periodic auto-update on Zsh startup: 'ask' or 'no'.
# You can manually run `z4h update` to update everything.
zstyle ':z4h:' auto-update      'ask'
# Ask whether to auto-update this often; has no effect if auto-update is 'no'.
zstyle ':z4h:' auto-update-days '15'

# Move prompt to the bottom when zsh starts and on Ctrl+L.
zstyle ':z4h:' prompt-at-bottom 'yes'

# Keyboard type: 'mac' or 'pc'.
zstyle ':z4h:bindkey' keyboard  'pc'

# Mark up shell's output with semantic information.
zstyle ':z4h:' term-shell-integration 'yes'

# Right-arrow key accepts one character ('partial-accept') from
# command autosuggestions or the whole thing ('accept')?
zstyle ':z4h:autosuggestions' forward-char 'accept'

# Recursively traverse directories when TAB-completing files.
zstyle ':z4h:fzf-complete' recurse-dirs 'yes'

#####=== Direnv

# Enable direnv to automatically source .envrc files.
zstyle ':z4h:direnv'         enable 'yes'
# Show "loading" and "unloading" notifications from direnv.
zstyle ':z4h:direnv:success' notify 'yes'

#####=== SSH

# Enable ('yes') or disable ('no') automatic teleportation of z4h over
# SSH when connecting to these hosts.
zstyle ':z4h:ssh:example-hostname1'   enable 'yes'
zstyle ':z4h:ssh:*.example-hostname2' enable 'no'
# The default value if none of the overrides above match the hostname.
zstyle ':z4h:ssh:*'                   enable 'yes'

# Send these files over to the remote host when connecting over SSH to the
# enabled hosts.
zstyle ':z4h:ssh:*' send-extra-files '~/.nanorc' '~/.env.zsh' '~/.zshutil'

#####=== GIT Clone

# Clone additional Git repositories from GitHub.
#
# This doesn't do anything apart from cloning the repository and keeping it
# up-to-date. Cloned files can be used after `z4h init`. This is just an
# example. If you don't plan to use Oh My Zsh, delete this line.
# z4h install ohmyzsh/ohmyzsh || return

# Install or update core components (fzf, zsh-autosuggestions, etc.) and
# initialize Zsh. After this point console I/O is unavailable until Zsh
# is fully initialized. Everything that requires user interaction or can
# perform network I/O must be done above. Everything else is best done below.
z4h init || return

#####=== Extend PATH.

# Personal bin
path=(~/bin $path)
# Add PIP binaries
PATH=$HOME/.local/bin:$PATH
# Add cargo bin
PATH=$HOME/.cargo/bin:$PATH
# Go
GOBIN=$HOME/go/bin
PATH=$GOBIN:$PATH
PATH=$PATH:/usr/local/go/bin
# export it all
export PATH

#####=== Export environment variables.
export GPG_TTY=$TTY
# Support additional terminal
export TERM=xterm-256color
# dch Settings for ubuntu packaging
export DEBFULLNAME="Dustin Krysak"
export DEBEMAIL="dustin@bashfulrobot.com"
# Set editor
export EDITOR=code-insiders
# Add colour to MAN pages
export MANPAGER="sh -c 'col -bx | bat -l man -p'"
# Go
export GOPATH=$HOME/go
export GOROOT=/usr/local/go
export GOBIN=$HOME/go/bin
export GO111MODULE=on

#####=== Source additional local files if they exist.
z4h source ~/.env.zsh
z4h source ~/.zshutil
# Enable COD binary
z4h source <(cod init $$ zsh)

# Use additional Git repositories pulled in with `z4h install`.
#
# This is just an example that you should delete. It does nothing useful.
#z4h source ohmyzsh/ohmyzsh/lib/diagnostics.zsh  # source an individual file
#z4h load   ohmyzsh/ohmyzsh/plugins/emoji-clock  # load a plugin

#####=== Define key bindings.

z4h bindkey z4h-backward-kill-word  Ctrl+Backspace     Ctrl+H
z4h bindkey z4h-backward-kill-zword Ctrl+Alt+Backspace

z4h bindkey undo Ctrl+/ Shift+Tab # undo the last command line change
z4h bindkey redo Alt+/            # redo the last undone command line change

z4h bindkey z4h-cd-back    Alt+Left   # cd into the previous directory
z4h bindkey z4h-cd-forward Alt+Right  # cd into the next directory
z4h bindkey z4h-cd-up      Alt+Up     # cd into the parent directory
z4h bindkey z4h-cd-down    Alt+Down   # cd into a child directory

#####=== Autoload functions.
autoload -Uz zmv

#####=== Define functions and completions.

# add shell completion for bw cli
eval "$(bw completion --shell zsh); compdef _bw bw;"

function md() { [[ $# == 1 ]] && mkdir -p -- "$1" && cd -- "$1" }
compdef _directories md

function myint() {
    ip -4 a | grep -v valid_lft | awk '{print $2}'
}

function catclip() {
    batcat -p $1 | xclip -i -selection clipboard
}

function myip() {
    hostname -I | awk '{print $1}'
}

function myip() {
    curl -s https://myip.biturl.top/ | cut -d "%" -f1
}

function do-update() {
    runAptUpdateIfNeeded
    sleep 1
    echoSection "Updating Distro"
    sudo apt dist-upgrade -y
    sleep 1
    echoSection "Performing Autoremove"
    sudo apt clean -y
    sudo apt autoremove -y
    sleep 1
    echoSection "Adding Missing Deps"
    sudo apt install -f -y
    sleep 1
    echoHeader "Completed System Update"
}

function gh-rate-limit-reset-time() {
    # Are the apps installed?
    checkInstalledApt jq
    checkInstalledApt curl

    date -d @$(curl -X GET https://api.github.com/rate_limit | jq .rate.reset)
}

function gh-rate-limit() {
    # Are the apps installed?
    checkInstalledApt curl
    curl -X GET https://api.github.com/rate_limit
}

bwcopy() {
    checkInstalledApt fzf
    checkInstalledApt jq
    checkInstalledApt xclip

    if hash bw 2>/dev/null; then
        bw get item "$(bw list items | jq '.[] | "\(.name) | username: \(.login.username) | id: \(.id)" ' | fzf-tmux | awk '{print $(NF -0)}' | sed 's/\"//g')" | jq '.login.password' | sed 's/\"//g' | xclip -sel clip
    fi
}

# add sudo before command with esc, s
function prepend-sudo() {
    [[ -z $BUFFER ]] && zle up-history
    if [[ $BUFFER == sudo\ * ]]; then
        LBUFFER="${LBUFFER#sudo }"
    else
        LBUFFER="sudo $LBUFFER"
    fi
}
zle -N prepend-sudo
# shortcut keys: [Esc] [s]
bindkey "\es" prepend-sudo

#####=== Define named directories: ~w <=> Windows home directory on WSL.
[[ -z $z4h_win_home ]] || hash -d w=$z4h_win_home

#####=== Define aliases.
alias tree='tree -a -I .git'

alias pcp='rsync -aP'

alias er='code-insiders -r'
alias e='code-insiders'
alias e-root='code-insiders --user-data-dir="~/.vscode-insiders/"'

alias opermissions="stat -c '%A %a %n'"
alias octperm="stat -c '%A %a %n'"

alias espanso-list="cat $HOME/.config/espanso/default.yml | grep trigger | cut -d ' ' -f5 | less"

alias vpn-login="/usr/bin/nordvpn login"
alias vpn-logout="/usr/bin/nordvpn logout"
alias vpn-up="/usr/bin/nordvpn connect"
alias vpn-down="/usr/bin/nordvpn disconnect"
alias vpn-countries="/usr/bin/nordvpn countries"
alias vpn-cities="/usr/bin/nordvpn cities"
alias vpn-settings="/usr/bin/nordvpn settings"
alias vpn-status="/usr/bin/nordvpn status"
alias vpn-account="/usr/bin/nordvpn account"
alias vpn-help="/usr/bin/brave-browser https://support.nordvpn.com/Connectivity/Linux/1325531132/Installing-and-using-NordVPN-on-Debian-Ubuntu-and-Linux-Mint.htm"

alias cat="batcat"
alias bat="batcat"
# Hide snap packages in df command
alias df="df -x squashfs"

alias k="kubectl"

alias d="docker"
alias g="git"
alias dc="docker-compose"

alias top="gotop"
alias htop="gotop"

if [ -d "$HOME/.bookmarks" ]; then
    export CDPATH=".:$HOME/.bookmarks:/"
    alias gt="cd -P"
fi

alias vi="~/Applications/nvim.appimage"
alias vim="~/Applications/nvim.appimage"
alias nvim="~/Applications/nvim.appimage"
alias neovim="~/Applications/nvim.appimage"

# Add flags to existing aliases.
alias ls="${aliases[ls]:-ls} -A"

#####=== Set shell options: http://zsh.sourceforge.net/Doc/Release/Options.html.
setopt glob_dots     # no special treatment for file names with a leading dot
setopt no_auto_menu  # require an extra TAB press to open the completion menu
