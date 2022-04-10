#!/bin/bash

# Interactive
export DEBIAN_FRONTEND=noninteractive

# COLORS 
readonly BLUE='\033[94m'
readonly  RED='\033[91m'
readonly  GREEN='\033[92m'
readonly  ORANGE='\033[93m'
readonly  RESET='\e[0m'

# CTRL + C
trap ctrl_c INT

function ctrl_c() {
    echo -e "\n\n${ORANGE}Exiting...${RESET}"
    exit
}

# Temporal dir to allow resources
readonly temp_folder=$(mktemp -d -q)

# Check status
function check_status() {
    if [ $? -eq 0 ] ; then
        sleep 0.5
        echo -ne "\n${GREEN}[${BLUE}+${RESET}${GREEN}]${RESET} ${GREEN}Sucessfull${RESET}" 
        sleep 0.5
    else
        echo -ne "${ORANGE}[${RED}-${RESET}${ORANGE}]${RESET} Error"
    fi
}

# logo
function logo(){
    echo ""
    echo -e "${ORANGE}  _   _   _   _   _   _   _   _   _   _   _   _  ${RESET}"
    echo -e "${ORANGE} / \ / \ / \ / \ / \ / \ / \ / \ / \ / \ / \ / \ ${RESET}"
    echo -e "${ORANGE}( S | w | e | e | t | - | P | a | r | r | o | t )${RESET}"
    echo -e "${ORANGE} \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_/ ${RESET}"
    echo ""
}

# Adding Repositories
function add_repo(){
sudo -s << \
'EOF'
    apt update 
    apt install -y bash wget git gnupg
    rm /etc/apt/sources.list 
    # Adding Mirror list
    echo "## Parrot 4.x Repositories" > /etc/apt/sources.list.d/parrot.list
    echo "deb https://deb.parrot.sh/parrot rolling main contrib non-free" >> /etc/apt/sources.list.d/parrot.list
    echo "deb https://deb.parrot.sh/parrot rolling-security main contrib non-free" >> /etc/apt/sources.list.d/parrot.list
    # Adding gpg keys 
    wget -qO - https://deb.parrotsec.org/parrot/misc/parrotsec.gpg | apt-key add -
    apt update
EOF
}


function pimp_my_desktop() {
    
    echo ""
    echo -e  "${BLUE}   _   _   _   _     _   _     _   _   _   _   _   _   _   ${RESET}"
    echo -e  "${BLUE}  / \ / \ / \ / \   / \ / \   / \ / \ / \ / \ / \ / \ / \  ${RESET}"
    echo -e  "${BLUE} ( P | i | m | p ) ( M | y ) ( D | e | s | k | t | o | p | ${RESET}"
    echo -e  "${BLUE}  \_/ \_/ \_/ \_/   \_/ \_/   \_/ \_/ \_/ \_/ \_/ \_/ \_/  ${RESET}"
    echo ""

    cd "${temp_folder}"

    # Oh My Zsh
    git clone https://github.com/ohmyzsh/ohmyzsh.git ~/.oh-my-zsh
    sudo git clone https://github.com/ohmyzsh/ohmyzsh.git /root/.oh-my-zsh 
    
    # Powerlvl10k - OhMyZsh
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/.config/powerlevel10k
    sudo git clone --depth=1 https://github.com/romkatv/powerlevel10k.git /root/.config/powerlevel10k
       
    #Fzf
    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.config/fzf ; ~/.config/fzf/install --all --key-bindings --completion --no-update-rc
    sudo git clone --depth 1 https://github.com/junegunn/fzf.git /root/.config/fzf ; sudo /root/.config/fzf/install --all --key-bindings --completion --no-update-rc
    
    # nano rc
    curl -sL https://raw.githubusercontent.com/scopatz/nanorc/master/install.sh | sh
    sudo curl -sL https://raw.githubusercontent.com/scopatz/nanorc/master/install.sh | sh
    
    # Repo 
    git clone https://github.com/0xl3mon/SweetParrot-XFCE ; cd SweetParrot-XFCE
    
    # Fuentes
    mkdir ~/.fonts ; mkdir -p ~/.local/share/{themes,icons}
    7z x usr/share/Fonts.7z && mv *.ttf ~/.fonts
    fc-cache -fv ~/.fonts
    
    # Themes
    7z x usr/share/themes/Sweet-Dark.7z
    mv Sweet-Dark/ ~/.local/share/themes/
    
    # Icons
    tar xzvf usr/share/icons/Papirus.tar.gz -C ~/.local/share/
    
    # Binaries
    sudo mv usr/bin-deb/batman /usr/local/bin ; sudo ln -s /usr/local/bin/batman /usr/bin/
    sudo dpkg -i usr/bin-deb/lsd-musl_0.21.0_amd64.deb 
    sudo dpkg -i  usr/bin-deb/bat-musl_0.20.0_amd64.deb

    # genmon xfce4
    mv bin ~/.local/
    
    # zsh p10k
    mv config/.p10k_user.zsh ~/.p10k.zsh
    sudo mv config/.p10k_root.zsh /root/.p10k.zsh

    # Custom zsh config
    mv config/.zshrc ~/.zshrc

    # Wallpapers
    mv wallpapers ~/.config/

    # Change Shell
    sudo chsh -s "$(which zsh)" $USER
    sudo chsh -s "$(which zsh)" root
    
    # Link p10k configuration to root folder
    user=$(whoami)
    sudo ln -s -f "/home/${user}/.zshrc" /root/.zshrc 

    # Xfce4-config
    rm -rf ~/.config/xfce4/
    7z x config/xfce4.7z ; mv xfce4 ~/.config
    
    # Autostart
    rm -rf ~/.cache/session ; rm -rf ~/.config/autostart 
    7z x config/autostart.7z ; mv autostart ~/.config

} 

function clipmenu(){
    cd "$temp_folder"

    # Dependencies
    sudo apt install  xsel libxtst-dev dmenu -y ; cd /tmp
    git clone https://github.com/cdown/clipnotify && cd clipnotify
    make && sudo make install
    cd ../

    #Clipmenu
    git clone https://github.com/cdown/clipmenu && cd clipmenu
    sudo make && sudo make install
}


function creating_swap(){
    # creating swap space
    sudo dd if=/dev/zero of=/swap2 bs=1024 count=1048576 
    # Set Permissions
    sudo chmod 600 /swap2
    # Set up swap area
    sudo mkswap /swap2
    # Enable Swap Partition
    sudo swapon /swap2
    sudo bash -c 'echo "/swap2        swap    swap    defaults    0    0" >> /etc/fstab'
}

function rofimoji(){
    cd "$temp_folder"

    sudo apt install suckless-tools rofi xdotool python3-pip -y
    wget -nv --show-progress $(curl -sL "https://api.github.com/repos/fdw/rofimoji/releases/latest" |  grep "browser_download" | sed 's/\(".*"\): \(".*"\)/\2/' | tr -d '"' | sed 's/[[:space:]]//g')
    python3 -m pip install rofimoji-*

    #rofi Theme
    mkdir ~/.config/rofi
    echo "rofi.theme: /usr/share/rofi/themes/glue_pro_blue.rasi" > ~/.config/rofi/config

    # rofimoji
    echo -e "action = copy\nskin-tone = neutral\nclipboarder = xclip" > ~/.config/rofimoji.rc

    # lnk
    sudo ln -s ~/.local/bin/rofimoji /usr/local/bin/rofimoji

}

function autostart_service(){
# Clipmenud Service
mkdir -p ~/.config/autostart 

cat <<EOF> ~/.config/autostart/clipmenud.service
[Desktop Entry]
Encoding=UTF-8
Version=0.9.4
Type=Application
Name=Clipmenud
Comment=clipboard service for clipmenu
Exec=/bin/clipmenud
OnlyShowIn=XFCE;
RunHook=0
StartupNotify=false
Terminal=false
Hidden=false
EOF

cat <<EOF> ~/.config/autostart/vmware-wrapper.xfce4-desktop
[Desktop Entry]
Encoding=UTF-8
Version=0.9.4
Type=Application
Name=Vmware Wrapper
Comment=Wrapper to copy and paste from outside to locally
Exec=/bin/vmware-user-suid-wrapper
OnlyShowIn=XFCE;
RunHook=0
StartupNotify=false
Terminal=false
Hidden=false
EOF

}

function main(){
    logo
    add_repo
    sudo chattr +i /etc/resolv.conf
    sudo apt install bash curl wget git gnupg xfce4-terminal -y
    sudo apt install parrot-desktop-xfce zsh fontconfig zsh-autosuggestions zsh-syntax-highlighting p7zip-full psmisc -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" -y 
    sudo parrot-upgrade
    sudo apt remove --purge "libreoffice-*" -y 
    sudo apt autoremove -y
    sudo update-alternatives --set x-terminal-emulator /usr/bin/xfce4-terminal.wrapper
    sudo chattr -i /etc/resolv.conf
    pimp_my_desktop
    clipmenu
    rofimoji
    xfconf-query -c xfce4-desktop -p /backdrop/screen0/monitorVirtual1/workspace0/last-image -s ~/.config/wallpapers/gasmask-skull.jpg
}


if [[ "$EUID" != "0" ]] ; then
    main ; check_status
    echo -e "\n${GREEN}[+]${RESET}${ORANGE} Sistema instalado correctamente ${RESET}"
    echo -ne "\n${GREEN}[+]${RESET}${ORANGE} Desea instalar una memoria swap adicional? (y/n) : " ; read swap_reply 
    if [[ "$swap_reply" =~ (y|Y) ]] ; then
        creating_swap 
        sleep 5
        /sbin/shutdown --reboot now
    else 
        echo -e "${GREEN}Reiniciando el sistema${RESET}"
        sleep 5
        /sbin/shutdown --reboot now
    fi 
else
    echo -e "${RED}[x]${RESET}Error : ${ORANGE}Do not run the script as root${RESET}"
    exit 1
fi

