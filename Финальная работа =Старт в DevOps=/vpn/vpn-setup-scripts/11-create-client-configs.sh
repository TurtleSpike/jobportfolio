#!/bin/bash

clientdir=`sudo find /home -type d -name clients`
curl ifconfig.me > /tmp/ipis
ipis=`cat /tmp/ipis`
rm /tmp/ipis

mkdir -p $clientdir/files
cp /usr/share/doc/openvpn/examples/sample-config-files/client.conf $clientdir/base.conf

basefile=$clientdir/base.conf

sudo sed -i "s/my-server-1/${ipis}/" $basefile

sudo sed -i '/^;user /c\user nobody' $basefile 
sudo sed -i '/^;group /c\group nogroup' $basefile

sudo sed -i '/^ca/{s/^/;/}' $basefile
sudo sed -i '/^cert/{s/^/;/}' $basefile
sudo sed -i '/^key/{s/^/;/}' $basefile

sudo sed -i '/^tls-auth/{s/tls-auth/;tls-crypt/}' $basefile

sudo sed -i '/cipher AES-256-CBC/{
s/^/;/
a\cipher AES-256-GCM\
auth SHA256\
key-direction 1
}' $basefile

echo -e '\033[92m = = = = Configuration file "base.conf" for the client has been added to the \033[4;92m'$clientdir'\033[m\033[92m directory and adjusted = = = = \033[m'
