# You can put files here to add functionality separated per file, which
# will be ignored by git.
# Files on the custom/ directory will be automatically loaded by the init
# script, in alphabetical order.

function options() {
    PLUGIN_PATH="$HOME/.oh-my-zsh/plugins/"
    for plugin in $plugins; do
        echo "\n\nPlugin: $plugin"; grep -r "^function \w*" $PLUGIN_PATH$plugin | awk '{print $2}' | sed 's/()//'| tr '\n' ', '; grep -r "^alias" $PLUGIN_PATH$plugin | awk '{print $2}' | sed 's/=.*//' |  tr '\n' ', '
    done
}

function asciinema-upload() {
    curl -v -u $USER:$(cat ~/.config/asciinema/install-id) https://asciinema.org/api/asciicasts -F asciicast=@$1
}

function myint() {
    ip -4 a | grep -v valid_lft | awk '{print $2}'
}

function catclip() {
    cat $1 | xclip -i -selection clipboard
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

function br-clone() {
    # Is GIT installed?
    checkInstalledApt git
    # Check if the repo exists already
    # GIT PULL if it does
    if [ -d "$HOME/tmp/$1" ]; then
        echo "Directory $HOME/tmp/$1 exists. Pulling remote repo instead."
        echo
        cd "$HOME/tmp/$1"
        git pull
        echo
    else
        # Repo does not exist, clone
        git clone git@github.com:bashfulrobot/$1 "$HOME/tmp/$1"
    fi

    echo
    echo "Current repo files ----"
    ls "$HOME/tmp/$1"
    echo
}

function rename-pad-num() {
    rename 's/\d+/sprintf("%04d",$&)/e' "$1"
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

function new-gh-repo() {
    gh repo create $1
    cd $1
    git checkout -b main
    git branch -D master

    cat <<EOF >LICENSE
MIT License

Copyright (c) 2021 Dustin Krysak

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

EOF

    cat <<EOF2 >README.md
# $1

## About

*** This $(README.md) was generated automatically. ***

$1 has only had the initial commit, so this document is a work in progress.

## Getting Started

Document how $1 will be installed and ready to use.

### Prerequisites

Describe any dependencies $1 will need.

## Usage

Describe how to use $1.

## License

MIT

## Author

Dustin Krysak

## Credits

If derived from other works, give credit to the authors.

EOF2

    git add LICENSE README.md
    git commit -m "🎉 Initial commit"
    git push --set-upstream origin main
}

rustscan() {
    ulimit -n 2000000
    docker run -it --rm --name rustscan rustscan/rustscan:1.10.0 "$1" -t 500 -- -A
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

transfer(){ if [ $# -eq 0 ];then echo "No arguments specified.\nUsage:\n transfer <file|directory>\n ... | transfer <file_name>">&2;return 1;fi;if tty -s;then file="$1";file_name=$(basename "$file");if [ ! -e "$file" ];then echo "$file: No such file or directory">&2;return 1;fi;if [ -d "$file" ];then file_name="$file_name.zip" ,;(cd "$file"&&zip -r -q - .)|curl --progress-bar --upload-file "-" "https://transfer.sh/$file_name"|tee /dev/null,;else cat "$file"|curl --progress-bar --upload-file "-" "https://transfer.sh/$file_name"|tee /dev/null;fi;else file_name=$1;curl --progress-bar --upload-file "-" "https://transfer.sh/$file_name"|tee /dev/null;fi;}