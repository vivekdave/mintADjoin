#!/bin/bash
#org.gnome.system.proxy use-same-proxy true
#org.gnome.system.proxy mode 'manual'
#org.gnome.system.proxy autoconfig-url ''
#org.gnome.system.proxy ignore-hosts ['localhost', '127.0.0.0/8', '::1']
#org.gnome.system.proxy.ftp host ''
#org.gnome.system.proxy.ftp port 0
#org.gnome.system.proxy.socks host ''
#org.gnome.system.proxy.socks port 0
#org.gnome.system.proxy.http host '10.0.0.1'
#org.gnome.system.proxy.http port 3128
#org.gnome.system.proxy.http use-authentication false
#org.gnome.system.proxy.http authentication-password ''
#org.gnome.system.proxy.http authentication-user ''
#org.gnome.system.proxy.http enabled false
#org.gnome.system.proxy.https host ''
#org.gnome.system.proxy.https port 0

sudo -u template HOME=/home/template dbus-launch --exit-with-session gsettings set org.gnome.system.proxy use-same-proxy true
sudo -u template HOME=/home/template dbus-launch --exit-with-session gsettings set org.gnome.system.proxy mode 'manual'
sudo -u template HOME=/home/template dbus-launch --exit-with-session gsettings set org.gnome.system.proxy ignore-hosts ['localhost', '127.0.0.0/8', '::1', 192.168.200.0/24, 10.0.0.0/24]
sudo -u template HOME=/home/template dbus-launch --exit-with-session gsettings set org.gnome.system.proxy.http host '10.0.0.1'
sudo -u template HOME=/home/template dbus-launch --exit-with-session  gsettings set org.gnome.system.proxy.http port 3128
