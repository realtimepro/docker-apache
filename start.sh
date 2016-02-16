#!/bin/bash
export TERM=xterm

if [ -z "`etc/apache2/sites-available`" ] 
then
	rsync -a /etc-start/apache2/sites-available/* /etc/apache2/sites-available
fi

service ssh start
# Start apache
/usr/sbin/apache2 -D FOREGROUND

