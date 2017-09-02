#!/bin/bash

## https://community.spiceworks.com/how_to/120234-linux-mint-17-1-lts-mate-ad-integration



echo -e "\e[1;32m Starting Process..."
echo -e "\e[1;37m"

echo -e "\e[1;32m Applying Proxy Server Settings for apt..."
echo -e "\e[1;37m"
sudo cp ./etc/02apt-proxy /etc/apt/apt.conf.d/
sudo chmod 644 /etc/apt/apt.conf.d/02apt-proxy

echo -e "\e[1;32m Applying Proxy Server Env Variables..."
echo -e "\e[1;37m"
sudo python3 ./bin/set_global_proxy.py


echo -e "\e[1;32m Adding Google Chrome PPA..."
echo -e "\e[1;37m"

export http_proxy="http://10.0.0.1:3128"
export https_proxy="http://10.0.0.1:3128"

wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add - 

sudo sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list'


echo -e "\e[1;32m Updating apt cache..."
echo -e "\e[1;37m"
sudo apt-get --yes update > /dev/null
echo -e "\e[1;32m Updating os..."
echo -e "\e[1;37m"
sudo apt-get --yes upgrade > /dev/null

#Remove unnecessary apps
echo -e "\e[1;32m Remove unnecessary apps..."
echo -e "\e[1;37m"
sudo apt-get --yes purge *hexchat* *pidgin* *transmission* *libreoffice* > /dev/null

echo -e "\e[1;32m Install Google Chrome..."
echo -e "\e[1;37m"

sudo apt-get --yes install google-chrome-stable > /dev/null

echo -e "\e[1;32m Installing multimedia apps and codecs..."
echo -e "\e[1;37m"
sudo apt-get --yes install mint-meta-codecs-core mint-meta-codecs vlc > /dev/null

echo -e "\e[1;32m Creating Template User..."
echo -e "\e[1;37m" 
#Create a template user for all AD accounts
sudo /bin/bash ./bin/create_user.sh

echo -e "\e[1;32m Applying Proxy Server Settings for template user..."
echo -e "\e[1;37m"
sudo -u template HOME=/home/template dbus-launch --exit-with-session gsettings set org.gnome.system.proxy use-same-proxy true
sudo -u template HOME=/home/template dbus-launch --exit-with-session gsettings set org.gnome.system.proxy mode 'manual'
sudo -u template HOME=/home/template dbus-launch --exit-with-session gsettings set org.gnome.system.proxy ignore-hosts "['localhost', '127.0.0.0/8', '::1', '192.168.200.0/24', '10.0.0.0/24']"
sudo -u template HOME=/home/template dbus-launch --exit-with-session gsettings set org.gnome.system.proxy.http host '10.0.0.1'
sudo -u template HOME=/home/template dbus-launch --exit-with-session gsettings set org.gnome.system.proxy.http port 3128

sudo -u template HOME=/home/template dbus-launch --exit-with-session gsettings set org.gnome.system.proxy.https host '10.0.0.1'
sudo -u template HOME=/home/template dbus-launch --exit-with-session gsettings set org.gnome.system.proxy.https port 3128

echo -e "\e[1;32m Applying Wallpaper and Slidshow for template user..."
echo -e "\e[1;37m"


sudo -u template HOME=/home/template dbus-launch --exit-with-session gsettings set org.cinnamon.desktop.background picture-uri 'file:///usr/share/backgrounds/linuxmint-serena/ajilden_blossom.jpg'
sudo -u template HOME=/home/template dbus-launch --exit-with-session gsettings set org.cinnamon.desktop.background color-shading-type 'solid'
sudo -u template HOME=/home/template dbus-launch --exit-with-session gsettings set org.cinnamon.desktop.background primary-color '#000000'
sudo -u template HOME=/home/template dbus-launch --exit-with-session gsettings set org.cinnamon.desktop.background picture-options 'zoom'
sudo -u template HOME=/home/template dbus-launch --exit-with-session gsettings set org.cinnamon.desktop.background picture-opacity 100
sudo -u template HOME=/home/template dbus-launch --exit-with-session gsettings set org.cinnamon.desktop.background secondary-color '#000000'

sudo -u template HOME=/home/template dbus-launch --exit-with-session gsettings set org.cinnamon.desktop.background.slideshow image-source 'xml:///usr/share/cinnamon-background-properties/linuxmint-serena.xml'
sudo -u template HOME=/home/template dbus-launch --exit-with-session gsettings set org.cinnamon.desktop.background.slideshow slideshow-paused false
sudo -u template HOME=/home/template dbus-launch --exit-with-session gsettings set org.cinnamon.desktop.background.slideshow random-order false
sudo -u template HOME=/home/template dbus-launch --exit-with-session gsettings set org.cinnamon.desktop.background.slideshow delay 15
sudo -u template HOME=/home/template dbus-launch --exit-with-session gsettings set org.cinnamon.desktop.background.slideshow slideshow-enabled true





echo -e "\e[1;32m Installing WPS Office and its fonts..."
echo -e "\e[1;37m"
#Install WPS Office and supporting fonts
sudo dpkg -i ./apps/wps-office_10.1.0.5707-a21_amd64.deb > /dev/null
sudo dpkg -i ./apps/web-office-fonts.deb > /dev/null
sudo unzip ./apps/wps_symbol_fonts.zip -d /usr/share/fonts/truetype/ > /dev/null

echo -e "\e[1;32m Updating Font Cache..."
echo -e "\e[1;37m"
# Update Font Cache
sudo fc-cache -fv > /dev/null

echo -e "\e[1;32m Installing Dconf..."
echo -e "\e[1;37m"
sudo apt-get --yes install dconf-editor dconf-cli > /dev/null

echo -e "\e[1;32m Installing Openssh..."
echo -e "\e[1;37m"
#Install openssh-server (Required for pbis ad join)
sudo apt-get --yes install openssh-server > /dev/null

#move to the pbis folder
#cd pbis-open-8.5.4.334.linux.x86_64.deb

#sudo chmod o+x ./install.sh

echo -e "\e[1;32m Installing Open PBIS AD Connector..."
echo -e "\e[1;37m"
#install pbis ad link
sudo /bin/bash ./bin/pbis-open-8.5.4.334.linux.x86_64.deb/install.sh --no-legacy install > /dev/null

echo -e "\e[1;32m Joining Domain..."
echo -e "\e[1;37m"
#join the domain
sudo /opt/pbis/bin/domainjoin-cli join --assumeDefaultDomain yes --userDomainPrefix TEST TEST.LAN domainjoin

echo -e "\e[1;32m Configuring PBIS..."
echo -e "\e[1;37m"
sudo /opt/pbis/bin/config LoginShellTemplate /bin/bash
sudo /opt/pbis/bin/config HomeDirTemplate %H/%U

echo -e "\e[1;32m Adding Domain Admins to Sudoers File..."
echo -e "\e[1;37m"
sudo cp ./etc/domain_admin_sudo /etc/sudoers.d/
sudo chmod 0440 /etc/sudoers.d/domain_admin_sudo

echo -e "\e[1;32m Updating lightDM Settings..."
echo -e "\e[1;37m"
sudo cp ./etc/LightDM_disableGuest_hideUsers.conf /etc/lightdm/lightdm.conf.d/ 

echo -e "\e[1;32m Installing libpam-mount..."
echo -e "\e[1;37m"
#install libpam-mount (Required to auto mont server cifs shares)
sudo apt-get --yes install libpam-mount > /dev/null

echo -e "\e[1;32m Installing xmlstarlet..."
echo -e "\e[1;37m"
#install xmlstarlet (Required to edit the pam_mount.conf.xml) which auto mounts fileshares per ad login
sudo apt-get --yes install xmlstarlet > /dev/null

echo -e "\e[1;32m Adding Share to pam-mount..."
echo -e "\e[1;37m"
sudo xmlstarlet ed -L -d //pam_mount/volume /etc/security/pam_mount.conf.xml
sudo xmlstarlet ed -L -a //pam_mount/debug -t elem -n "volume" /etc/security/pam_mount.conf.xml
sudo xmlstarlet ed -L -i //pam_mount/volume -t attr -n "sgrp" -v 'TEST\share' /etc/security/pam_mount.conf.xml
sudo xmlstarlet ed -L -i //pam_mount/volume -t attr -n "user" -v '*' /etc/security/pam_mount.conf.xml
sudo xmlstarlet ed -L -i //pam_mount/volume -t attr -n "fstype" -v 'cifs' /etc/security/pam_mount.conf.xml
sudo xmlstarlet ed -L -i //pam_mount/volume -t attr -n "server" -v 'DC01' /etc/security/pam_mount.conf.xml
sudo xmlstarlet ed -L -i //pam_mount/volume -t attr -n "path" -v 'share' /etc/security/pam_mount.conf.xml
sudo xmlstarlet ed -L -i //pam_mount/volume -t attr -n "mountpoint" -v '~/adMounts/share' /etc/security/pam_mount.conf.xml

echo -e "\e[1;32m add a template to ad accounts..."
echo -e "\e[1;37m"
# Call the python3 script which add a template to ad accounts
sudo python3 ./bin/apply_user_profile_template.py /etc/pam.d/common-session > /dev/null

echo -e "\e[1;32m Install the Railway Theme..."
echo -e "\e[1;37m"
#--install-suggests
sudo chmod -R 777 railway-cinnamon-master
cd railway-cinnamon-master
sudo /bin/bash install.sh > /dev/null
cd ..

echo -e "\e[1;32m Apply the railway Theme to template..."
echo -e "\e[1;37m"

sudo -u template HOME=/home/template dbus-launch --exit-with-session gsettings set org.cinnamon.theme name Railway

gsettings set org.cinnamon.theme name Railway




