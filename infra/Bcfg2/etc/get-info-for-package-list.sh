#!/bin/bash
echo -e "\n\t<!-- Dependances de $1 -->"
for i in `cat $1`;do
DESC=`dpkg -p $i|grep Description:|cut -f2- -d:`
DISPNAME="<Package name='$i'/>"
DISPDESC="<!--$DESC -->"
printf "\t%-49s %s\n" "$DISPNAME" "$DISPDESC"
done
