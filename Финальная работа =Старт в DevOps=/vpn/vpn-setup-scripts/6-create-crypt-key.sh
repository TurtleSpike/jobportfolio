#!/bin/bash

easydir=`sudo find /home -type d -name easy-rsa`
vpnsh=`whereis openvpn | awk -F ' ' '{print $2}'`

cd $easydir
$vpnsh --genkey secret ta.key

if [ $? -eq 0 ]
then
  echo -e '\033[92m = = = = Cryptokey "ta.key" has been created = = = = \033[m'
else
  echo -e '\033[91m = = = = Cryptokey has NOT been created = = = = \033[m'
  exit 1
fi

sudo cp $easydir/ta.key /etc/openvpn/server

echo -e '\033[92m = = = = and copied to the \033[4;92m/etc/openvpn/server\033[m\033[92m directory = = = = \033[m'
