#!/bin/bash
## Bootstrap script for Xubuntu 22.04 (run as your own user account which has passwordless sudo, not ROOT!!)

[ $(whoami) == "root" ] && { echo "run this as non-root user with passwordless sudo..exiting"; exit 1; }

cd /opt

### DECRAP
sudo apt-get -y remove --purge libreoffice* thunderbird* rhythmbox* ristretto* nano
sudo apt-get clean
sudo apt-get -y autoremove
sudo apt -y update

## google chrome
wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -
sudo echo "deb http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list

# Brave browser
sudo apt install -y apt-transport-https curl
sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg arch=amd64] https://brave-browser-apt-release.s3.brave.com/ stable main"|sudo tee /etc/apt/sources.list.d/brave-browser-release.list

## Firefox browser
#cd ~/Downloads 
#FF_VER="109.0.1"
#sudo rm -rf /opt/firefox/ /usr/bin/firefox
#curl -L -o firefox.tar.bz2 https://download-installer.cdn.mozilla.net/pub/firefox/releases/${FF_VER}/linux-x86_64/es-ES/firefox-${FF_VER}.tar.bz2
#tar -xf firefox.tar.bz2
#rm -rf firefox.tar.bz2
#sudo mv firefox /opt
#sudo ln -s /opt/firefox/firefox /usr/bin/firefox
#echo -e "[Desktop Entry]\nEncoding=UTF-8\nName=Firefox\nComment=Firefox\nExec=/opt/firefox/firefox %u\nTerminal=false\nIcon=/opt/firefox/browser/chrome/icons/default/default128.png\nStartupWMClass=Firefox\nType=Application\nCategories=Network;WebBrowser;\nMimeType=text/html;text/xml;application/xhtml+xml;application/xml;application/vnd.mozilla.xul+xml;application/rss+xml;application/rdf+xml;x-scheme-handler/http;x-scheme-handler/https;\nStartupNotify=true\n" | sudo tee -a /usr/share/applications/firefox.desktop


# various
sudo add-apt-repository ppa:andrewsomething/typecatcher

# vscode
wget -q https://packages.microsoft.com/keys/microsoft.asc -O- | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main"


sudo apt -y update

### PKGS
sudo apt install -y software-properties-common apt-transport-https wget 
sudo apt install -y nomacs
sudo apt install brave-browser -y
sudo apt install build-essential -y
sudo apt install stacer -y
sudo apt install ffmpeg -y
sudo apt install tuned -y
sudo apt install fish -y
sudo apt install zsh zsh-autosuggestions zsh-common zsh-syntax-highlighting -y
sudo apt install earlyoom -y
sudo apt install geoclue-2.0 -y
sudo apt install git -y
sudo apt install google-chrome-stable -y
sudo apt install htop -y
sudo apt install gnome-calculator -y
sudo apt install libbz2-dev -y
sudo apt install wireshark -y
sudo apt install libc6-dev -y
sudo apt install libffi-dev -y
sudo apt install libgdbm-dev -y
sudo apt install libncursesw5-dev -y
sudo apt install libreadline-gplv2-dev -y
sudo apt install libsqlite3-dev -y
sudo apt install libssl-dev -y
sudo apt install ncdu -y
sudo apt install blueman -y
sudo apt install hardinfo -y
sudo apt install system-config-printer -y
sudo apt install net-tools -y
sudo apt install nmap -y
sudo apt install network-manager-openvpn -y
sudo apt install network-manager-openvpn-gnome -y
sudo apt install playonlinux -y
sudo apt install redshift -y
sudo apt install redshift-gtk -y
sudo apt install resolvconf -y
sudo apt install snapd -y
sudo apt install tcpdump -y
sudo apt install terminator -y
sudo apt install typecatcher -y
sudo apt install tk-dev -y
sudo apt install vim -y
sudo apt install virtualbox -y
sudo apt install flatpak -y
sudo apt install vlc -y
sudo apt install jq -y
sudo apt install zlib1g-dev -y
sudo apt install wine64 wine32 winetricks -y
sudo apt-get install msttcorefonts -y
sudo apt install code -y
sudo apt install filezilla -y
sudo apt install file-roller -y
sudo apt install gedit -y
sudo apt install openssh-server -y
sudo apt install vagrant -y
sudo apt-get install nfs-common nfs-kernel-server
vagrant plugin install vagrant-vbguest vagrant-disksize

##### disable netplan + GRUB
sudo apt install net-tools ifupdown
sudo sed -i -e "s/GRUB_CMDLINE_LINUX=\".*\"/GRUB_CMDLINE_LINUX=\"net.ifnames=0 biosdevname=0\"/g" /etc/default/grub
sudo update-grub

#### RC files
cp files/.bashrc ~
cp files/.zshrc ~

## AnyDesk
sudo wget -qO - https://keys.anydesk.com/repos/DEB-GPG-KEY | apt-key add -
sudo echo "deb http://deb.anydesk.com/ all main" > /etc/apt/sources.list.d/anydesk-stable.list
sudo apt update
sudo apt install anydesk


###################################
# battery and power
sudo apt-get install tlp tlp-rdw -y
sudo systemctl enable tlp
sudo apt install powertop -y
sudo apt install cpufrequtils -y


# set CPU governor for laptops to powersave, for desktops use performance
# available cpufreq governors: conservative, ondemand, userspace, powersave, performance, schedutil

echo -e "\n updating CPU profile depending on whether Desktop or Laptop"
chassis=$(sudo dmidecode --string chassis-type)
if [ $chassis == "Desktop" ]
then
  echo "Desktop - setting CPU to performance"
  for ((i=0; i<$(nproc); i++)); do sudo cpufreq-set -g performance -c $i; done
else
  echo "Laptop - setting CPU to powersave"
  for ((i=0; i<$(nproc); i++)); do sudo cpufreq-set -g powersave -c $i; done
  
  # disable screensaver for long battery usage
  echo "xset s off" >> ~/.xsession
fi



## librewolf browser
sudo apt update && sudo apt install -y wget gnupg lsb-release apt-transport-https ca-certificates

## Julia lang
wget https://julialang-s3.julialang.org/bin/linux/x64/1.8/julia-1.8.5-linux-x86_64.tar.gz
tar zxvf julia-1.8.5-linux-x86_64.tar.gz
sudo mv julia-1.8.5 /opt/
sudo ln -s /opt/julia-1.8.5/bin/julia /usr/bin/julia


### thinlinc
wget https://www.cendio.com/downloads/clients/thinlinc-client_4.14.0-2324_amd64.deb
sudo dpkg -i thinlinc-client_4.14.0-2324_amd64.deb

#######################
## RustDesk
wget https://github.com/rustdesk/rustdesk/releases/download/1.1.9/rustdesk-1.1.9.deb
sudo dpkg -i rustdesk-1.1.9.deb

## Croc Send
curl https://getcroc.schollz.com | bash

## fatcat
sudo apt install -y libevent-dev
wget https://github.com/perfecto25/fcat/releases/download/0.1.3/fcat-0.1.3-ubuntu21
sudo mv fcat* /usr/local/bin/fcat
sudo chmod +x /usr/local/bin/fcat
sudo ln -s /usr/local/bin/fcat /usr/bin/fcat

sudo pip3 install youtube-dl pipenv

### SNAPS
sudo snap install inkscape
sudo snap install dbeaver-ce
sudo snap install crystal
sudo snap install onlyoffice-desktopeditors
sudo snap install remmina
sudo snap install ksnip
sudo snap install pinta

## photoshop CC
git clone https://github.com/Gictorbit/photoshopCClinux.git
# run setup.sh to install PS

# set VIM
echo -e "colo desert\nset number" >> ~/.vimrc

### install modern CLI tools
  # batcat
  sudo apt -y install bat
  echo "alias cat \"/usr/bin/batcat\"" >> ~/.config/fish/config.fish
  echo "alias cat='/usr/bin/batcat'" >> ~/.bashrc
  
  # lazygit
  curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/download/v0.36.0/lazygit_0.36.0_Linux_x86_64.tar.gz"
  sudo tar xf lazygit.tar.gz -C /usr/local/bin lazygit


  ### install rust/cargo
  sudo apt -y install cargo
  cargo install nu  # nu shell
  cargo install procs
  cargo install fd-find

#### move window to next monitor
apt-get -y install wmctrl xdotool
wget https://raw.githubusercontent.com/jc00ke/move-to-next-monitor/master/move-to-next-monitor
mv move-to-next-monitor /usr/local/bin/
chmod +x /usr/local/bin/move-to-next-monitor
## Open settings manager -> keyboard -> application shortcuts
## Click Add (/usr/local/bin/move-to-next-monitor
## assign Control + m

## Appimages
mkdir ~/AppImages
cd ~/AppImages
wget https://github.com/balena-io/etcher/releases/download/v1.14.3/balenaEtcher-1.14.3-x64.AppImage
chmod +x balenaEtcher* 

## Themes
mkdir ~/.themes
cd ~/.themes
git clone https://github.com/paullinuxthemer/PRO-Dark-XFCE-Edition.git
git clone https://github.com/i-mint/LightningBug.git
mv PRO-Dark-XFCE-Edition/PRO-dark-XFCE-4.14 .
mv LightningBug/Lightningbug-Solid .
mv LightningBug/Lightningbug-Dark .
mv LightningBug/Lightningbug-Solid-Dark .
rm -rf PRO-Dark-XFCE-Edition
rm -rf LightningBug

## add Terminator themes
cp files/terminator_config ~/.config/terminator/config

### Swapiness
sudo echo "vm.swappiness = 10" >> /etc/sysctl.conf

## flatpak sources
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo



echo "Install slack manually, snap pkg has broken icon"
echo "Bootstrap complete, reboot this box now."
