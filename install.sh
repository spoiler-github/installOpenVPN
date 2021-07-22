#!/bin/bash

osname=$(cat /etc/os-release | grep ID_LIKE)
pass=$(openssl rand -base64 12)
ip=$(ip a | grep inet | awk '{print$2}' | grep /24 | rev | cut -c4- | rev)

grep -i fedora /etc/os-release > /dev/null && osname='centos'
echo "centos"

if [[ $osname = "ID_LIKE=debian" ]]
then
  apt update
  apt upgrade -y
  apt install net-tools
  curl -O http://swupdate.openvpn.org/as/openvpn-as-2.5.2-Debian9.amd_64.deb
  dpkg -i openvpn-as-*.deb > /dev/null
elif [[ $osname = "centos" ]]
then
  yum -y update
  yum install net-tools
  curl -O http://swupdate.openvpn.org/as/openvpn-as-2.7.3-CentOS7.x86_64.rpm
  rpm --install openvpn-as-*.rpm > /dev/null
fi

echo -e "\n\n\n\n\n"

echo 'openvpn:'$pass|chpasswd -
echo 'Hello,'
echo 'OpenVPN install has been finished'
echo 'Admin login: openvpn'
echo 'Password:' $pass
echo 'Web URL: https://'$ip':943/admin'
