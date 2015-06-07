# (ES) Script post-instalación para Debian
# (EN) Debian post-installation script
#
# Author  : Jose Manuel Cerrejon Gonzalez (ulysess _at._ gmail _.dot_ com)
# Updated : 07/Jun/15
# Tested  : Debian 8 Jessie (Stable) XFCE 64 bits
# Download: debian.org/CD/http-ftp/#stable 
# Website : http://misapuntesde.com
#
# INSTRUCCIONES (ES)
# 1) Instalar sudo y otorgar permisos al usuario actual con el comando (como root): adduser your_user sudo
# 2) Copiar este script a un fichero, otorgar permisos de ejecución con chmod +x post.sh y asegurarse de tener acceso a internet.
# 3) Leer CUIDADOSAMENTE cada línea y añadir/remover el símbolo de almohadilla '#' en las acciones que necesites (salvo en los comentarios).
# 4) Recuerda hacer backups de programas, bookmarks, configuraciones y addons de navegadores, mail ,~/.bashrc, ~/.ssh, ~/gnupg...
# 5) Ejecutar ./post.sh
#
# INSTRUCTIONS (EN)
# 1) Install sudo and add current user to sudo with the command (as root): adduser your_user sudo
# 2) Copy the script to a file and set execution priviledge with: chmod +x post.sh and make sure you have internet connection.
# 3) Read CAREFULLY each line on this file and add/remove the '#' symbol when you need it. (keep comments).
# 4) Remember to make backups(apps, bookmarks, config files, browsers addons, mail ,~/.bashrc, ~/.ssh, ~/gnupg…)
# 5) Run ./post.sh
# 
# Script start!
#
# REMEMBER Install sudo and add current user to sudoers!
#
# Remove cdrom from repos and add contrib non-free to /etc/apt/sources.list
#sudo sed -i '/cdrom/s/^/#/' /etc/apt/sources.list
#sudo sed -i 's/main/main contrib non-free/g' /etc/apt/sources.list
# Best repos you can find (Spain & Europe)
FILE="\n
deb http://ftp.fr.debian.org/debian jessie main contrib non-free\n
deb http://ftp.fr.debian.org/debian jessie-updates main contrib non-free\n
deb http://ftp.fr.debian.org/debian jessie-backports main contrib non-free\n
deb http://security.debian.org jessie/updates main contrib non-free\n
deb http://www.deb-multimedia.org jessie main non-free\n
deb http://www.deb-multimedia.org/ jessie-backports main\n
"
sudo echo -e $FILE > /etc/apt/sources.list
wget http://www.deb-multimedia.org/pool/main/d/deb-multimedia-keyring/deb-multimedia-keyring_2014.2_all.deb
sudo dpkg -i deb-multimedia-keyring_2014.2_all.deb
rm deb-multimedia-keyring_2014.2_all.deb

sudo apt update
#
# Remove packages
#
sudo apt remove -y aspell aspell-en bsd-mailx ca-certificates-java java-common cups-common cups-pk-helper doc-debian docbook-xml docutils-common docutils-doc emacsen-common espeak-data libreoffice-help-en-us libreoffice-java-common libreoffice-draw libreoffice-math libreoffice-report-builder-bin libreoffice-base-drivers libreoffice-calc xfburn exfalso gimp-data xsane-common libsane libsane-common libsane-extras libsane-extras-common  xfce4-notes xfce4-notes-plugin firebird2.5-server-common firebird2.5-common-doc i965-va-driver installation-report procmail vim-common w3m wamerican xserver-xorg-input-wacom vlc-data
sudo apt upgrade && sudo apt-get -y autoremove && sudo apt-get autoclean
#
# Install packages
#
# Optionals:
# winff: audio & video converter
# wine-development: Wine is a free MS-Windows API implementation
# flashplugin-nonfree: If you don’t use Chrome
# libreoffice-writer: Who the hell use the entire LibreOffice suite?
# rdesktop: To connect to remote servers using RDP protocol (Windows)
# converseen: Resize images,...
# xfce4-screenshooter: take screenshots
# fbreader: epub reader
# jpegoptim pngquant: image optimizer
# mediainfo: Info about media files
#
sudo apt install -y build-essential readahead preload autoconf2.13 dkms synaptic mpv git dialog mc htop udisks libcurl3 clipit sshfs libnotify-bin libappindicator1 file-roller software-properties-common unzip p7zip curl ristretto catfish ntfs-3g
# autologin using lightdm
sudo sed -i 's/#autologin-user=/autologin-user='$USER'/g' /etc/lightdm/lightdm.conf
sudo sed -i 's/#autologin-user-timeout=0/autologin-user-timeout=0/g' /etc/lightdm/lightdm.conf
#
# Aditional software
#
# Install ATI drivers (Doesn’t work wget. You must to download the package manually)
#
# Method 1
sudo aptitude -r install linux-headers-$(uname -r|sed 's,[^-]*-[^-]*-,,') fglrx-driver
sudo aticonfig --initial
#
# Method 2
#wget http://www2.ati.com/drivers/linux/amd-catalyst-omega-14.12-linux-run-installers.zip
#unzip amd* && cd fgl*
#sudo ./amd*.run
# Install Google Chrome
wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
sudo sh -c 'echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list'
sudo apt update && sudo apt install google-chrome-stable
# Install Steam. WARNING: Maybe the system goes unstable!
# Guide: http://linuxconfig.org/installation-of-steam-client-on-debian-jessie-8-linux-64bit 
wget http://media.steampowered.com/client/installer/steam.deb
sudo dpkg -i steam.deb
sudo apt -f install
sudo dpkg --add-architecture i386
sudo apt install -y libgl1-mesa-dri:i386 libgl1-mesa-glx:i386 libc6:i386
sudo apt install -y  libgl1-fglrx-glx-i386
# Docker
sudo curl -sSL https://get.docker.com/ | sh
sudo usermod -aG docker $USER
# To test Docker: sudo docker run -i -t ubuntu /bin/bash
# Spotify
echo "deb http://repository.spotify.com stable non-free" | sudo tee -a /etc/apt/sources.list
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 94558F59 
sudo apt update 
sudo apt install -y spotify-client
wget http://ftp.au.debian.org/debian/pool/main/libg/libgcrypt11/libgcrypt11_1.4.5-2+squeeze3_amd64.deb
sudo dpkg -i libgcrypt* && rm libgcrypt*
# Sublime Text 2
wget http://c758482.r82.cf2.rackcdn.com/Sublime%20Text%202.0.2%20x64.tar.bz2
tar xvf Subl*
mv Sublime\ Text\ 2 /opt/st2
rm -rf Subl*
# Oracle Java 8
sudo sh -c 'echo "deb http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main" >> /etc/apt/sources.list'
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys EEA14886
sudo apt update
echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | sudo /usr/bin/debconf-set-selections
sudo apt update && sudo apt install -y oracle-java8-installer
# ffmpeg,mkvtoolnix, mkvtoolnix-gui (+ info: http://deb-multimedia.org/)
wget http://www.deb-multimedia.org/pool/main/d/deb-multimedia-keyring/deb-multimedia-keyring_2014.2_all.deb
sudo dpkg -i deb-multimedia-keyring_2014.2_all.deb
rm deb-multimedia-keyring_2014.2_all.deb
sudo sh -c 'echo "deb http://www.deb-multimedia.org jessie main non-free" >> /etc/apt/sources.list'
sudo sh -c 'echo "deb http://www.deb-multimedia.org jessie-backports main" >> /etc/apt/sources.list'
sudo apt update && sudo apt install -y ffmpeg mkvtoolnix mkvtoolnix-gui
# TeamViewer
sudo dpkg --add-architecture i386 ; sudo apt update ;
sudo apt install -y libc6:i386 libgcc1:i386 libasound2:i386 libfreetype6:i386 zlib1g:i386 libsm6:i386 libxdamage1:i386 libxext6:i386 libxfixes3:i386 libxrandr2:i386 libxrender1:i386 libxtst6:i386 libjpeg62-turbo:i386 libxinerama1:i386
wget -p ~/Downloads http://downloadeu1.teamviewer.com/download/version_10x/teamviewer_10.0.41499_amd64.deb
sudo dpkg -i ~/Downloads/teamviewer_i386.deb
rm ~/Downloads/teamviewer_i386.deb
# Plank
sudo add-apt-repository "deb http://ppa.launchpad.net/ricotz/docky/ubuntu precise main" && sudo apt update && sudo apt install plank
# Whisker Menu
wget http://download.opensuse.org/repositories/home:gottcode/Debian_8.0/Release.key && sudo apt-key add - < Release.key
sudo sh -c "echo 'deb http://download.opensuse.org/repositories/home:gottcode/Debian_8.0/ /' >> /etc/apt/sources.list.d/xfce4-whiskermenu-plugin.list"
# Pinta
sudo sh -c "echo 'deb http://ppa.launchpad.net/pinta-maintainers/pinta-stable/ubuntu trusty main' >> /etc/apt/sources.list"
sudo apt update
sudo apt install -y mono-runtime pinta
# Lutris Installer. More info at https://lutris.net
sudo apt install -y gvfs-backends python-xdg python-yaml
wget -P $HOME http://lutris.net/releases/lutris_0.3.6.3_all.deb
sudo dpkg -i $HOME/lutris_0.3.6.3_all.deb
rm $HOME/lutris_0.3.6.3_all.deb
# Birdie (Twitter client)
sudo apt install -y libgtksourceview-3.0-1 libpurple0 libgee2
wget https://github.com/birdieapp/birdie/releases/download/1.1/birdie_1.1-debian_amd64.deb
sudo dpkg -i birdie_1.1-debian_amd64.deb
rm birdie_1.1-debian_amd64.deb
# DBeaver (MySQL GUI tool)
wget http://dbeaver.jkiss.org/files/dbeaver_3.4.0_amd64.deb
sudo dpkg -i dbeaver_3.4.0_amd64.deb
rm dbeaver_3.4.0_amd64.deb
# XFCE 4.12
sudo sh -c "echo 'deb http://main.mepis-deb.org/mepiscr/repo/ mepis12cr main' >> /etc/apt/sources.list.d/xfce.list"
wget http://teharris.net/m12repo.asc
su -c "apt-key add m12repo.asc"
rm m12repo.asc
sudo apt-get update && sudo apt-get dist-upgrade -y --force-yes
sudo ln -s /usr/lib/x86_64-linux-gnu/libxfce4util.so.7 /usr/lib/x86_64-linux-gnu/libxfce4util.so.6
#
# Tweaks
# 
# flash use GPU
sudo mkdir /etc/adobe/
sudo sh -c 'echo "EnableLinuxHWVideoDecode=1" >> /etc/adobe/mms.cfg'
sudo sh -c 'echo "OverrideGPUValidation=1" >> /etc/adobe/mms.cfg'
# Add flattr icon theme
sudo git clone https://github.com/NitruxSA/flattr-icons.git /usr/share/icons/flattr
# Add Numix circle icon theme (You must to get rid of master dir. I’ll fix it soon)
#sudo wget -P /usr/share/icons https://github.com/numixproject/numix-icon-theme-circle/archive/master.zip && sudo unzip -nq $(basename $_) && sudo rm $(basename $_)
# Window decorations (extract to ~/.themes/)
# http://ugoyak.deviantart.com/art/G-Talkie-XFCE-Window-Decorations-505068210 
# Some usefull alias: upd, ins, reboot, halt
sed -i "/# Alias definitions/i\alias upd='sudo apt update && sudo apt-get dist-upgrade -y && sudo apt-get autoremove -y && sudo apt-get clean && sudo apt-get autoclean'" $HOME/.bashrc
sed -i "/# Alias definitions/i\alias reboot='sudo reboot'" $HOME/.bashrc
sed -i "/# Alias definitions/i\alias ins='sudo apt install -y '" $HOME/.bashrc
sed -i "/# Alias definitions/i\alias halt='sudo halt'" $HOME/.bashrc
sed -i "/# Alias definitions/i\alias rm='sudo rm -rf '" $HOME/.bashrc
# Grub menu to 1 second
sudo sed -i 's/set timeout=5/set timeout=1/g' /boot/grub/grub.cfg
# Fixes
# Error: Can’t uninstall glx-diversions
# Just edited the first line of the file /var/lib/dpkg/info/glx-diversions.postrm with exit 0 and apt-get remove glx-diversions
# Error: error while loading shared libraries: libGL.so.1
# sudo apt install -y libgl1-fglrx-glx
# Allow parallel starts
sudo sh -c 'echo "CONCURRENCY=shell" >> /etc/default/rcS'
# Disable IPV6
sudo sh -c 'echo "net.ipv6.conf.all.disable_ipv6=1" > /etc/sysctl.d/disableipv6.conf' && sudo sh -c 'echo 'blacklist ipv6' >> /etc/modprobe.d/blacklist' && sudo sed -i '/::/s%^%#%g' /etc/hosts
# CPU Governor to performance
echo -n performance | sudo tee /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
# Dash free up +1 MB RAM
sudo dpkg-reconfigure dash -y
# Improve writing disk & free cache blocks
sudo sh -c "echo 'vm.swappiness=20' >> /etc/sysctl.conf"
sudo sh -c "echo 'vm.vfs_cache_pressure=50' >> /etc/sysctl.conf"
# enable dependency-based boot-ordering
dpkg-reconfigure insserv

# Interesting links and commands:
#
# https://wiki.archlinux.org/index.php/Desktop_notifications
# Check if webcam is ok: mplayer tv:// 
