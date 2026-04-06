#!/bin/bash

clientname=$1
easydir=`sudo find /home -type d -name easy-rsa`
transfer=/home/$USER/transfer

cd $transfer
git pull origin master

cd $easydir
./easyrsa import-req $transfer/$clientname.req $clientname

if [ $? -eq 0 ]
then
  echo -e '\033[92m = = = = Client request "'$clientname'.req" has been imported = = = = \033[m'
else
  echo -e '\033[91m = = = = Client request "'$clientname'.req" has NOT been imported or has already been imported = = = = \033[m'
fi

rm $transfer/$clientname.req

./easyrsa sign-req client $clientname

if [ $? -eq 0 ]
then
  echo -e '\033[92m = = = = Client request "'$clientname'.req" has been signed = = = = \033[m'
else
  echo -e '\033[91m = = = = Client request "'$clientname'.req" has NOT been signed = = = = \033[m'
  exit 1
fi

cp $easydir/pki/issued/$clientname.crt $transfer
git add .
git commit -m "Client certificate $clientname being sent to VPN server"
git push

echo -e '\033[92m = = = = and client certificate has been copied to the remote transfer repository = = = = \033[m'

