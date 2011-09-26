# Kickstart  $Id: centos.ks 654 2009-08-26 13:53:38Z dave $ 
# BCFG2-CSBE

install
nfs --server=172.30.2.104  --dir=/home/CentOS/5/isos/i386
repo --name=csbe --baseurl=http://172.30.2.104/csbe
text
skipx
lang en_US.UTF-8
keyboard us
network --device eth0 --bootproto dhcp
rootpw q1w2e3
firewall --disabled
authconfig --enableshadow --enablemd5
selinux --permissive
timezone --utc America/Montreal
bootloader --location=mbr --driveorder=sda
reboot
# The following is the partition information you requested
# Note that any partitions you deleted are not expressed
# here so unless you clear all partitions first, this is
# not guaranteed to work
clearpart --all --drives=sda
part /boot --fstype ext3 --size=100 --ondisk=sda
part pv.2 --size=0 --grow --ondisk=sda
volgroup VolGroup00 --pesize=32768 pv.2
logvol / --fstype ext3 --name=LogVol00 --vgname=VolGroup00 --size=1024 --grow
logvol swap --fstype swap --name=LogVol01 --vgname=VolGroup00 --size=256 --grow --maxsize=512

%packages
@ core
bcfg2
yum
openssh-clients
openssh-server

%post
chkconfig bluetooth off
chkconfig ip6tables off
#chkconfig yum-updatesd off
chkconfig gpm off
chkconfig isdn off
chkconfig cups off
chkconfig atd off
chkconfig apmd off
chkconfig hidd off
chkconfig firstboot off
chkconfig kudzu off
chkconfig mdmonitor off
chkconfig pcscd off
#chkconfig messagebus off
chkconfig hplip off
chkconfig mdmonitor off
chkconfig avahi-daemon off
chkconfig anacron off
chkconfig autofs off
chkconfig haldaemon off
chkconfig portmap off
chkconfig readahead_early off
chkconfig readahead_later off

if [ ! -e /etc/bcfg2.conf ]; then

    (
    cat << 'EOF'
[communication]
protocol = xmlrpc/ssl
password = 1myQzJAf
fingerprint = d7cc9bcd657944970b847e563a115bc3f8cf4903

[components]
bcfg2 = https://172.30.2.102:6789
encoding = UTF-8

EOF
    ) > /etc/bcfg2.conf
fi

bcfg2 -v -q -k 2>&1 | tee /root/bcfg2.`date +%F-%R:%S`
bcfg2 -v -q -k 2>&1 | tee /root/bcfg2.`date +%F-%R:%S`

rpm -e sendmail

/usr/sbin/useradd -p 'saEmc/IpB0bMc' ddoyon
/usr/sbin/useradd -p 'saPGkxyFezgbA' gestionsti
