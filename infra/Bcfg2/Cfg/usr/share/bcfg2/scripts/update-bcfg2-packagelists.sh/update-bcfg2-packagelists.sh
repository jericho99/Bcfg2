#!/bin/bash

BCFG2DIR="/var/lib/bcfg2"
BCFG2CONFDIR="$BCFG2DIR/etc"
PKGMGRDIR="$BCFG2DIR/Pkgmgr"

UPCENTOS="$BCFG2CONFDIR/createrpmlist-bcfg2.sh"
UPUBUNTU="$BCFG2CONFDIR/create-debian-pkglist.py"

# Clean local files
rm -f "$PKGMGRDIR/*"

# Update files
svn up "$PKGMGRDIR" > /dev/null

# Run the update script
sh $UPCENTOS
python $UPUBUNTU


if [ "$?" -eq "0" ]; then
    svn ci -m"Auto-update of package lists $(date +%D)" "$PKGMGRDIR" > /dev/null
else
    echo "Error with the package list update script."
    exit 1
fi

exit 0

