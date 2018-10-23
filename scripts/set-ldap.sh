#!/bin/bash

whoami
cat /etc/redhat-release

yum install -y autofs
systemctl enable autofs
sed -i '$a/home   /etc/auto.home' /etc/auto.master
cat >> /etc/auto.home <<!
*       -fstype=nfs,rw,soft,intr,rsize=32768,wsize=32768        hzlinn10.china.nsn-net.net:/vol/hzlinn10_home/home/&
!
systemctl restart autofs \
&& echo -e "\e[32;1mSuccess: autofs configuration.\e[0m"


yum install -y ypbind
cat >> /etc/yp.conf <<!
# primary NIS servers
domain eelinnis.emea.nsn-net.net server hzlina10.china.nsn-net.net
# backup NIS servers
domain eelinnis.emea.nsn-net.net server belina10.china.nsn-net.net
domain eelinnis.emea.nsn-net.net server cdlina10.china.nsn-net.net
!
sed -e 's/^passwd:.*/passwd:     files nis sss ldap/' \
    -e 's/^shadow:.*/shadow:     files nis sss ldap/' \
    -e 's/^group:.*/group:      files nis sss ldap/' \
    -e 's/^\(initgroups:.*\)/#&/' \
    -e 's/^hosts:.*/hosts:      files nis dns/' \
    -e 's/^netgroup:.*/netgroup:   files nis sss ldap/' \
    -e 's/^automount:.*/automount:  files nis ldap/' \
    -i.bak /etc/nsswitch.conf
systemctl enable ypbind
systemctl start ypbind
if yptest | head -20 | grep juejlu;then
	echo -e "\e[32;1mSuccess: ypbind configuration.\e[0m"
fi

yum install -y openldap-clients
yum install -y nss-pam-ldapd pam_ldap
sed -e 's#^TLS_CACERTDIR.*#TLS_CACERTDIR /etc/openldap/cacerts#' \
    -e '$aURI ldap://ed-p-gl.emea.nsn-net.net:389' \
    -e '$aBASE ou=People, o=NSN' \
    -i.bak /etc/openldap/ldap.conf
authconfig --enableldap --enableldapauth --ldapserver='ldap://ed-p-gl.emea.nsn-net.net:389' --ldapbasedn='ou=People, o=NSN' --enableshadow --enablelocauthorize --passalgo=sha256 --update
systemctl restart nslcd
sed -e 's/^PasswordAuthentication.*/PasswordAuthentication yes/' \
    -e 's/^ChallengeResponseAuthentication.*/ChallengeResponseAuthentication yes/' \
    -i.bak /etc/ssh/sshd_config
systemctl restart sshd \
&& echo -e "\e[32;1mSuccess: ldap configuration.\e[0m"


mkdir -p /build/ltesdkroot
mkdir -p /build/rcp
mkdir -p /mnt/pkgpool/home/SC_LFS
cat >> /etc/fstab <<!
eslinn11.emea.nsn-net.net:/vol/eslinn11_ltesdk/build/build/ltesdkroot     /build/ltesdkroot  nfs  soft,intr,retry=1,rw,rsize=32768,wsize=32768  0 0
eslinn10.emea.nsn-net.net:/vol/eslinn10_ltesdkrcp_bin/rcp                 /build/rcp         nfs  soft,intr,retry=1,rw,rsize=32768,wsize=32768  0 0
eslinn60.emea.nsn-net.net:/vol/eslinn60_home/home                         /home              nfs  soft,intr,retry=1,rw,rsize=32768,wsize=32768  0 0
ullinn12.emea.nsn-net.net:/vol/ullinn12_lfs/SC_LFS     /mnt/pkgpool/home/SC_LFS              nfs  soft,intr,retry=1,rw,rsize=32768,wsize=32768  0 0
!
mount -a \
&& echo -e "\e[32;1mSuccess: home&nfs mount.\e[0m"
