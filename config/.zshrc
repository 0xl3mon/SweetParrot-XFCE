#---------------------
#    Path
#---------------------
export PATH=/sbin:/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/root/.local/bin:/home/l3mon/.local/bin

# Enable Powerlevel10k instant prompt. Should stay at the top of ~/.zshrc.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Auto-Suggestions Color
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#757575'

# Fzf
#FZF_DEFAULT_OPS="--extended"
FZF_DEFAULT_COMMAND='find .'

#---------------------
#  Env Variables Zsh
#---------------------
HISTSIZE=1000
SAVEHIST=1000
HISTFILE=~/.zsh_history

#------------------
#	Oh My Zsh
#------------------

# Path to yout oh-my-zsh installation
export ZSH="$HOME/.oh-my-zsh"

# Uncomment the following line if pasting is messed up
DISABLE_MAGIC_FUNCTIONS="true"

# Plugins
plugins=(sudo)

source $ZSH/oh-my-zsh.sh

# Auto-Completion System
autoload -U compinit && compinit

# Golang Path
export GOROOT=/usr/local/go
export PATH=$PATH:/usr/local/go/bin

#---------------------
#  Plugins ZSH
#---------------------
source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh

#---------------------
#    Alias
#---------------------
alias ls='lsd --group-dirs=first -l'
alias ip='ip -c'
alias cat="bat --paging never -p --theme 'Monokai Extended Origin'"
alias grep="grep --color=auto"
alias man='/usr/bin/batman'


# HTB
alias htb-vpn='openvpn /home/l3mon/Descargas/lab_rafster.ovpn'

# Burpsuite
alias burp="/opt/burpsuite_pro_v2022.2.2/loader-burp.sh"

# One Liner
alias oneliner="one-lin3r -x list"

# Config
alias zshconfig='nano ~/.zshrc'

# Goland
alias goland='/opt/GoLand-2021.1.3/bin/goland.sh &>/dev/null & ; disown'

#---------------------
#    Bindkey
#---------------------
bindkey "^[[1;5D" backward-word
bindkey "^[[1;5C" forward-word
bindkey '^[[3;5~' kill-word
bindkey '^H' backward-kill-word
bindkey '^[[H' beginning-of-line
bindkey '^[[F' end-of-line

bindkey '^_' autosuggest-enable
bindkey '^[/' autosuggest-disable

# Disable Ctrl+d to avoid close terminal
set -o ignoreeof

#----------------
#   Functions
#----------------

#Copy Ports Nmap
function copy-ports() {
    ports="$(cat $1 | grep -oP '\d{1,5}/open' | cut -d / -f1 | xargs | tr ' ' ',')"
    echo -e "\n[*] Ports : $ports"
    echo -n $ports | xclip -sel clip
    }

# Create Directories 
function mkd() {
        mkdir -p nmap content exploit privesc && cd nmap
        }

# Wifi Pentest 
    function monitor-init() {
        airmon-ng start wlan0 && echo -e "\n[+] Enabling mode Monitor"
        sleep 0.5
        (killall wpa_supplicant 2>/dev/null) && echo -e "\n[+] Killed Process dhclient, wpa_supplicant"
        sleep 0.5
        ifconfig wlan0mon down && echo -e "[+] Network Interface: Down"
        sleep 0.5
        macchanger -a wlan0mon && echo -e "\n[+] Setting a Random Mac for our Iface"
        sleep 0.5
        ifconfig wlan0mon up  && echo -e "\n[+]Network Interface: Up"
    }

    function close-monitor() {
        ip link set wlan0mon down  && echo -e "\n[+] Network interface : Down"
        sleep  0.5
        macchanger -p wlan0mon && echo -e "\n[+] Restarting default Mac"
        sleep 0.5
        ip link set wlan0mon up &&  echo -e "\n[+] Network interface: Up"
        sleep 0.5
        airmon-ng stop wlan0mon &&  echo -e "\n[+] Disabling Monitor Mode :  Success"
    }

# Obfuzcate
    function bmcs() {
        return="$(pwd)" ; [[ -z "$(ls | grep .sln)" ]] && break || xbuild /p:Configuration=Release /verbosity:minimal /nologo | tail -n+2
        mkdir /root/xbuilds &> /dev/null ; cp $(find . -name "*.exe" | xargs -L1 ls++ | head -n1) /root/xbuilds/ ; cd /root/xbuilds ; app="$(ls *.exe -1t | head -n1)"
        cd /usr/local/bin/net-obfuscate ; mono NET-Obfuscate.exe --in-file /root/xbuilds/"$app" ; cd $return ; ls++ -1t /root/xbuilds/
    }

# Getlanding
    function getlanding() {
        cd /tmp ; randdir="$(openssl rand -hex 6)" ; mkdir $randdir ; cd $randdir
        wget --wait=2 --level=inf --limit-rate=320K --recursive --page-requisites --user-agent=Mozilla --no-parent --convert-links --adjust-extension --no-clobber -e robots=off "$1"
        ls */*
    }

# Random char
    function rnd() {
        echo $(tr -dc 'A-Z0-9a-z' < /dev/urandom | head -c $1)
    }

# Aria2c
    function dn() {
        aria2c -x 16 -j 64 -s 64 -c $1
    }


# Clip
    function cb() {
        cat "$1" | xclip -selection c
    }

# Speed Test 
    function speedtest() {
        curl -s https://raw.githubusercontent.com/sivel/speedtest-cli/master/speedtest.py | python3 -
    }

# Upload
    function upl() {
        result="$(curl -s --upload-file $1 $HOSTNAME:4466)" ; echo $result
    }


# Go To home
cd ~

# Source powerlvl-theme
source ~/.config/powerlevel10k/powerlevel10k.zsh-theme

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

