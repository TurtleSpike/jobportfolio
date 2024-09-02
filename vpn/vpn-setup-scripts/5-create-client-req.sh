#!/bin/bash

easydir=`sudo find /home -type d -name easy-rsa`
sudo find /home -type d -name clients > dir.ex
transfer=/home/$USER/transfer

if [ ! -s dir.ex ]
then
	makeclientdir=$1
	clientname=$2
	mkdir -p $makeclientdir/clients/keys
	clientdir=`sudo find /home -type d -name clients`
	chmod -R 700 $clientdir
	echo -e '\033[92m = = = = Directory "clients" has been created. Its path is \033[4;92m'$clientdir'\033[m\033[92m = = = = \033[m'
else
	clientname=$1
fi

rm dir.ex

cd $easydir
./easyrsa gen-req $clientname nopass

if [ $? -eq 0 ]
then
  echo -e '\033[92m = = = = Client certificate request "'$clientname'.req" and client key "'$clientname'.key" have been created = = = = \033[m'
else
  echo -e '\033[91m = = = = Client certificate request and client key have NOT been created = = = = \033[m'
  exit 1
fi

cp $easydir/pki/private/$clientname.key $clientdir/keys/
cp $easydir/pki/reqs/$clientname.req $transfer
git pull origin master
git add .
git commit -m 'Client certificate request being sent to PKI server'
git push

echo -e '\033[92m = = = = Client certificate request "'$clientname'.req" has been created and copied to the remote transfer repository = = = = \033[m'
echo -e '\033[92m = = = = Client key "'$clientname'.key" has been copied to the \033[4;92m'$clientdir'/keys\033[m\033[92m directory = = = = \033[m'
