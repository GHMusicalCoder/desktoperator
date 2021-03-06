# You can put files here to add functionality separated per file, which
# will be ignored by git.
# Files on the custom/ directory will be automatically loaded by the init
# script, in alphabetical order.

alias pcp='rsync -aP'

alias er='code-insiders -r'
alias e='code-insiders'
alias e-root='code-insiders --user-data-dir="~/.vscode-insiders/"'

alias opermissions="stat -c '%A %a %n'"
alias octperm="stat -c '%A %a %n'"

alias s="gnome-control-center sound"

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
alias cfg-update="$HOME/tmp/bashfulrobot-ansible/deploy.sh"

alias editorconfig-init="cp $HOME/.config/editorconfig/.editorconfig ."
alias uncrustify-init="cp $HOME/.config/uncrustify/.uncrustify.cfg ."

alias oni2="${HOME}/Documents/bin/Onivim2-x86_64.AppImage"

alias gen-passwd="${HOME}/Documents/bin/generate-passwd.sh"

alias gh-init="/usr/local/bin/github-init-main.sh"

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
