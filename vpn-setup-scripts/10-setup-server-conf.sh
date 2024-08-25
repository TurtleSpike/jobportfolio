#!/bin/bash

sudo apt-get install iptables-persistent

if [ $? -eq 0 ]
then
  echo -e '\033[92m = = = = Packages have been installed = = = = \033[0m'
else
  echo -e '\033[91m = = = = Packages have NOT been installed = = = = \033[m'
  exit 1
fi

servername=$1
sudo cp /usr/share/doc/openvpn/examples/sample-config-files/server.conf /etc/openvpn/server/$servername.conf

sercon=/etc/openvpn/server/$servername.conf

sudo sed -i '/^tls-auth ta.key/{
s/^/;/
a\tls-crypt ta.key
}' $sercon

sudo sed -i '/cipher AES-256-CBC/{
s/^/;/
a\cipher AES-256-GCM\
auth SHA256
}' $sercon 

sudo sed -i '/dh dh2048.pem/{
s/^/;/
a\dh none
}' $sercon 
sudo sed -i '/dh dh.pem/{
s/^/;/
a\dh none
}' $sercon 

sudo sed -i '/^;user /c\user nobody' $sercon 
sudo sed -i '/^;group /c\group nogroup' $sercon

sudo sed -i "/^cert server.crt/{s/server.crt/$servername.crt/}" $sercon
sudo sed -i "/^key server.key/{s/server.key/$servername.key/}" $sercon

sudo sed -i '/^;push "redirect/{s/;push/push/}' $sercon

echo -e '\033[92m = = = = Configuration file for the "'$servername'" server has been added to the \033[4;92m'$sercon'\033[m\033[92m directory and adjusted = = = = \033[m'

sudo chmod 666 /etc/sysctl.conf
echo "net.ipv4.ip_forward = 1" >> /etc/sysctl.conf
sudo chmod 644 /etc/sysctl.conf 
sudo sysctl -p

echo -e '\033[92m = = = = Value of "net.ipv4.ip_forward" parameter has been set to "1" = = = = \033[m'

int=`ip a | awk -F': ' '/^2: /{print $2}'`

# OpenVPN
sudo iptables -A INPUT -i $int -m state --state NEW -p udp --dport 1194 -j ACCEPT
# ALlow TUN interface connections to OpenVPN server
sudo iptables -A INPUT -i tun+ -j ACCEPT
# Allow TUN interface connections to be forwarded through other interfaces
sudo iptables -A FORWARD -i tun+ -j ACCEPT
sudo iptables -A FORWARD -i tun+ -o "$int" -m state --state RELATED,ESTABLISHED -j ACCEPT
sudo iptables -A FORWARD -i "$int" -o tun+ -m state --state RELATED,ESTABLISHED -j ACCEPT
# NAT the VPN client traffic to the internet
sudo iptables -t nat -A POSTROUTING -s 10.8.0.0/24 -o "$int" -j MASQUERADE

sudo iptables -A INPUT -i lo -j ACCEPT
sudo iptables -A INPUT -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
sudo iptables -A INPUT -p tcp --dport 80 -j ACCEPT
sudo iptables -A INPUT -p tcp --dport 443 -j ACCEPT
sudo iptables -A INPUT -p tcp --dport 22 -j ACCEPT
sudo iptables -A INPUT -p tcp --dport 21 -j ACCEPT
sudo iptables -A INPUT -p tcp --dport 443 -j ACCEPT
sudo iptables -A INPUT -p udp --dport 1194 -j ACCEPT
sudo iptables -A INPUT -p tcp --dport 9090 -j ACCEPT
sudo iptables -A INPUT -p tcp --dport 9100 -j ACCEPT

sudo iptables -P INPUT DROP
sudo iptables -P FORWARD DROP
sudo iptables -P OUTPUT ACCEPT

sudo service netfilter-persistent save

echo -e '\033[92m = = = = Configuration of network and firewall rules for the "'$servername'" server have been adjusted = = = = \033[m'

sudo systemctl -f enable openvpn-server@$servername.service
echo -e '\033[92m = = = = "'$servername'" server has been enabled with including it in startup = = = = \033[m'
sudo systemctl start openvpn-server@$servername.service
echo -e '\033[92m = = = = and started = = = = \033[m'
