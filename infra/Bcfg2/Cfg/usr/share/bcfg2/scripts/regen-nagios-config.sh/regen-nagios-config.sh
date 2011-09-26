#!/bin/bash

# THIS FILE IS OWNED BY BCFG2
# Local modifications WILL be lost

cd /etc/nagios2/templates/
/bin/rm -f /etc/nagios2/auto.d/*
/usr/bin/cheetah compile *.tmpl
/usr/bin/python parser.py
/etc/init.d/nagios2 stop
/bin/sleep 2
/etc/init.d/nagios2 start

