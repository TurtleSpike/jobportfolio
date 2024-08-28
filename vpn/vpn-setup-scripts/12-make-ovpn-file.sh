#!/bin/bash
# First argument: Client identifier

clientdir=`sudo find /home -type d -name clients`
KEY_DIR=$clientdir/keys
OUTPUT_DIR=$clientdir/files
BASE_CONFIG=$clientdir/base.conf
cat ${BASE_CONFIG} \
<(echo -e '<ca>') \
${KEY_DIR}/ca.crt \
<(echo -e '</ca>\n<cert>') \
${KEY_DIR}/${1}.crt \
<(echo -e '</cert>\n<key>') \
${KEY_DIR}/${1}.key \
<(echo -e '</key>\n<tls-crypt>') \
${KEY_DIR}/ta.key \
<(echo -e '</tls-crypt>') \
> ${OUTPUT_DIR}/${1}.ovpn

cd /home/$USER/transfer
git pull origin master
git add .
git commit -m 'OVPN file has been added'
git push

echo -e '\033[92m = = = = "'$1'.ovpn" VPN file has been created in the \033[4;92m'$OUTPUT_DIR'\033[m\033[92m directory = = = = \033[m'
echo -e '\033[92m = = = = and copied to the remote transfer repository = = = = \033[m'


