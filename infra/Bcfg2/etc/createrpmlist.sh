#!/bin/sh 
#$ID$
dest="/home/dave/SUBVERSION/infra/Bcfg2/Pkgmgr"
ori="/home/dave/SUBVERSION/infra/Bcfg2/etc"
$ori/pkgmgr_gen.py -y http://mirror.centos.org/centos/5/os/i386/ -p 40 -P -o $dest/centos5-i386.xml -g centos5,i386
$ori/pkgmgr_gen.py -y http://mirror.centos.org/centos/5/os/x86_64/ -p 40 -P -o $dest/centos5-x86_64.xml -g centos5,x86_64
$ori/pkgmgr_gen.py -y http://mirror.centos.org/centos/5/extras/i386/ -p 30 -P -o $dest/centos5-extras-i386.xml -g centos5,i386
$ori/pkgmgr_gen.py -y http://mirror.centos.org/centos/5/extras/x86_64/ -p 30 -P -o $dest/centos5-extras-x86_64.xml -g centos5,x86_64
$ori/pkgmgr_gen.py -y http://mirror.centos.org/centos/5/updates/i386/ -p 50 -P -o $dest/centos5-updates-i386.xml -g centos5,i386
$ori/pkgmgr_gen.py -y http://mirror.centos.org/centos/5/updates/x86_64/ -p 50 -P -o $dest/centos5-updates-x86_64.xml -g centos5,x86_64
$ori/pkgmgr_gen.py -y http://apt.sw.be/redhat/el5/en/i386/rpmforge/ -p 10 -P -o $dest/dag-i386.xml -g centos5,i386
$ori/pkgmgr_gen.py -y http://apt.sw.be/redhat/el5/en/x86_64/rpmforge/ -p 10 -P -o $dest/dag-x86_64.xml -g centos5,x86_64
$ori/pkgmgr_gen.py -y http://mirror.csclub.uwaterloo.ca/fedora/epel/5/i386/ -p 20 -P -o $dest/epel-i386.xml -g centos5,i386
$ori/pkgmgr_gen.py -y http://mirror.csclub.uwaterloo.ca/fedora/epel/5/x86_64/ -p 20 -P -o $dest/epel-x86_64.xml -g centos5,x86_64
$ori/pkgmgr_gen.py -y http://rpms.infoglobe.ca/IGL/i386/ -p 8 -P -o $dest/igl-i386.xml -g centos5,i386
$ori/pkgmgr_gen.py -y http://rpms.infoglobe.ca/IGL/x86_64/ -p 8 -P -o $dest/igl-x86_64.xml -g centos5,x86_64
