#!/bin/bash
service ssh start
# Start apache
/usr/sbin/apache2 -D FOREGROUND

