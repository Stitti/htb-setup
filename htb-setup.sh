#!/bin/bash

cat >> '

 █████   █████ ███████████ ███████████      █████████            █████                        
░░███   ░░███ ░█░░░███░░░█░░███░░░░░███    ███░░░░░███          ░░███                         
 ░███    ░███ ░   ░███  ░  ░███    ░███   ░███    ░░░   ██████  ███████   █████ ████ ████████ 
 ░███████████     ░███     ░██████████    ░░█████████  ███░░███░░░███░   ░░███ ░███ ░░███░░███
 ░███░░░░░███     ░███     ░███░░░░░███    ░░░░░░░░███░███████   ░███     ░███ ░███  ░███ ░███
 ░███    ░███     ░███     ░███    ░███    ███    ░███░███░░░    ░███ ███ ░███ ░███  ░███ ░███
 █████   █████    █████    ███████████    ░░█████████ ░░██████   ░░█████  ░░████████ ░███████ 
░░░░░   ░░░░░    ░░░░░    ░░░░░░░░░░░      ░░░░░░░░░   ░░░░░░     ░░░░░    ░░░░░░░░  ░███░░░  
                                                                                     ░███     
                                                                                     █████    
                                                                                    ░░░░░   
                                                                                    
'



while true; do
    read -p "Do you want to fix the monitor resolution? " yn
    case $yn in
        [Yy]* ) 
            printf '\n============================================================\n'
            printf '[+] Fixing resolution\n'
            printf '============================================================\n\n'
            xrandr --newmode "2560x1080_60" 230.76  2560 2728 3000 3440  1080 1081 1084 1118  -HSync +Vsync
            xrandr --addmode Virtual1 2560x1080_60
            xrandr --output Virtual1 --mode 2560x1080_60
            break;;
        [Nn]* ) 
            break;;
        * ) echo "Please answer yes or no.";;
    esac
done

if ! command -v openvpn &> /dev/null
then
    printf '\n============================================================\n'
    printf '[+] Installing OpenVPN \n'
    printf '============================================================\n\n'
    apt-get install openvpn -y
    printf 'Installed OpenVPN\n'
fi

printf '\n============================================================\n'
printf '[+] Add Alias for OpenVPN \n'
printf '============================================================\n\n'
printf 'Set alias htbon to start openvpn connection to htb\n'
if  grep -q "htbon" ~/.zshrc ; then
    printf 'htbon already exists\n';
else
    read -p "Path to open vpn config file " filename
    echo "alias htbon='openvpn ${filename}>/dev/null &'" >> ~/.zshrc
fi

printf 'Set alias htboff to stop openvpn\n'
if  grep -q "htboff" ~/.zshrc ; then
    echo 'htboff already exists';
else
    echo "alias htboff='pkill openvpn'" >> ~/.zshrc
    printf 'Set alias htbon to start openvpn connection to htb\n'
fi

printf '\n============================================================\n'
printf '[+] Showing your IP Address in zsh\n'
printf '============================================================\n\n'
cp -f ~/.zshrc ./.zshrc
printf 'After restarting your terminal your ip address gets displayed\n'


printf '\n============================================================\n'
printf '[+] Initializing Metasploit Database\n'
printf '============================================================\n\n'
systemctl start postgresql
systemctl enable postgresql
msfdb init

printf '\n============================================================\n'
printf '[+] Disabling Animations\n'
printf '============================================================\n\n'
gsettings set org.gnome.desktop.interface enable-animations false
printf 'Disabled animations\n'

printf '\n============================================================\n'
printf '[+] Disabling Terminal Transparency\n'
printf '============================================================\n\n'
profile=$(gsettings get org.gnome.Terminal.ProfilesList default)
profile=${profile:1:-1}
gsettings set "org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$profile/" use-transparent-background false
gsettings set org.gnome.desktop.wm.preferences button-layout appmenu:minimize,maximize,close
printf 'Disabled terminal transparency\n'

printf '\n============================================================\n'
printf '[+] Unzipping RockYou\n'
printf '============================================================\n\n'
gunzip /usr/share/wordlists/rockyou.txt.gz 2>/dev/null
ln -s /usr/share/wordlists ~/Downloads/wordlists 2>/dev/null
printf 'Unzipped RockYou wordlist\n'

while true; do
    read -p "Install all available updates? " yn
    case $yn in
        [Yy]* ) 
            printf '\n============================================================\n'
            printf '[+] Installing Updates\n'
            printf '============================================================\n\n'
            apt-get update -y
            apt-get full-upgrade -y 
            break;;
        [Nn]* ) 
            break;;
        * ) echo "Please answer yes or no.";;
    esac
done

printf '\n============================================================\n'
printf '[+] Restarting zsh\n'
printf '============================================================\n\n'
zsh
source ~/.zshrc

printf '\n Restart your terminal'