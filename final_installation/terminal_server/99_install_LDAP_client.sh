#!/bin/bash

sudo apt install --assume-yes debconf-utils

echo "ldap-auth-config    ldap-auth-config/bindpw    password    blub
ldap-auth-config    ldap-auth-config/rootbindpw    password    bla
ldap-auth-config    ldap-auth-config/ldapns/ldap_version    select    3
ldap-auth-config    ldap-auth-config/move-to-debconf    boolean    true
ldap-auth-config    ldap-auth-config/dblogin    boolean    false
ldap-auth-config    ldap-auth-config/dbrootlogin    boolean    false
ldap-auth-config    ldap-auth-config/pam_password    select    crypt
ldap-auth-config    ldap-auth-config/ldapns/ldap-server    string    132.187.198.16
ldap-auth-config    ldap-auth-config/ldapns/base-dn    string    dc=cctb,dc=uni-wuerzburg,dc=de
ldap-auth-config    ldap-auth-config/binddn    string    cn=proxyuser,dc=example,dc=net
ldap-auth-config    ldap-auth-config/rootbinddn    string    cn=admin,dc=cctb,dc=uni-wuerzburg,dc=de
ldap-auth-config    ldap-auth-config/override    boolean    true" | sudo debconf-set-selections

sudo apt install --assume-yes ldap-auth-config libpam-ldap nscd rpcbind libnss-ldap

# change the nsswhich information for passwd group shadow and gshadow
for i in passwd group shadow gshadow
do
    sed -i '/^'"$i"':/s/^\('"$i"':[[:space:]]*\).*$/\1compat ldap # added ldap by installation script/g' /etc/nsswitch.conf
done

# enabe password change via passwd
sudo sed -i 's/use_authtok[[:space:]]*//' /etc/pam.d/common-password

echo "Replace password for LDAP root, please enter password, followed by <ENTER> and afterwards close with <Ctrl-D>"
cat | sudo tee /etc/ldap.secret
sudo chmod 600 /etc/ldap.secret

sudo service nscd restart
