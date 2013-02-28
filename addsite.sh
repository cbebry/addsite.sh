#!/bin/bash

# *******************************************************************
# addsite, version 1.1
# MIT / X11 License
#
# Copyright (C) 2011-Today Christopher Bebry
#
# Permission is hereby granted, free of charge, to any person obtaining a copy 
# of this software and associated documentation files (the "Software"), to deal 
# in the Software without restriction, including without limitation the rights to 
# use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of 
# the Software, and to permit persons to whom the Software is furnished to do so, 
# subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all 
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, 
# INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A 
# PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT 
# HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF 
# CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE 
# OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#
# *******************************************************************
#
# Description:
#  Used to easily create sites for use with VirtualHosts in 
#	Apache2.x. The filesystem information is hardcoded on
#	purpose. Supply your system-specific information.
#
# 	Takes a single argument, which is the name of the site.
#	Input sanitization does not occur. It is assumed that 
#	this script is always run with an understanding of how it 
#	works. If you use it otherwise, that's only your fault.
#
# Usage:
#	cd /srv
#	sudo ./addsite.sh nameofsite.com
# *******************************************************************

ROOT_UID=0	# Only users with $UID 0 have root privileges.
E_NOTROOT=87	# Non-root exit error.

# Configurable parameters
SERVER_IP="173.255.202.140"
SERVER_PORT="80"
SERVER_ADMIN="admin@spectrumbranch.com"

# Run as root only
if [ "$UID" -ne "$ROOT_UID" ]
then
  echo "Must be root to run this script."
  exit $E_NOTROOT
else
  # User is root.
  if [ $1 ]
  then
    # Site argument is provided
    SITE_NAME=$1
    DIR_PREFIX=/srv/www/
    DIR_SITE_SUFFIX=/public_html/
    DIR_LOGS_SUFFIX=/logs/
    DIR_SITE=$DIR_PREFIX$SITE_NAME$DIR_SITE_SUFFIX
    DIR_LOGS=$DIR_PREFIX$SITE_NAME$DIR_LOGS_SUFFIX
    
    ERROR_LOG=error.log
    CUSTOM_LOG="access.log combined"

    APACHE2_OUTPUT_FILE=/etc/apache2/sites-available/$SITE_NAME

    APACHE2_SITEFILE_LINE1="<VirtualHost $SERVER_IP:$SERVER_PORT>"
    APACHE2_SITEFILE_LINE2="\tServerAdmin $SERVER_ADMIN"
    APACHE2_SITEFILE_LINE3="\tServerName $SITE_NAME"
    APACHE2_SITEFILE_LINE4="\tServerAlias www.$SITE_NAME"
    APACHE2_SITEFILE_LINE5="\tDocumentRoot $DIR_SITE"
    APACHE2_SITEFILE_LINE6="\tErrorLog $DIR_LOGS$ERROR_LOG"
    APACHE2_SITEFILE_LINE7="\tCustomLog $DIR_LOGS$CUSTOM_LOG"
    APACHE2_SITEFILE_LASTLINE="</VirtualHost>"

    if [ ! -d "$DIR_PREFIX$SITENAME" ]
    then
      echo Directory already exists: $DIR_PREFIX$SITENAME
      exit 1
    else
      if [ -f "$APACHE2_OUTPUT_FILE" ]
      then
        echo Apache2 site file already exists: $APACHE2_OUTPUT_FILE
        exit 1
      else
        mkdir $DIR_PREFIX$SITE_NAME
        mkdir $DIR_SITE
        mkdir $DIR_LOGS
      
        echo -e $APACHE2_SITEFILE_LINE1 > $APACHE2_OUTPUT_FILE
        echo -e $APACHE2_SITEFILE_LINE2 >> $APACHE2_OUTPUT_FILE
        echo -e $APACHE2_SITEFILE_LINE3 >> $APACHE2_OUTPUT_FILE
        echo -e $APACHE2_SITEFILE_LINE4 >> $APACHE2_OUTPUT_FILE
        echo -e $APACHE2_SITEFILE_LINE5 >> $APACHE2_OUTPUT_FILE
        echo -e $APACHE2_SITEFILE_LINE6 >> $APACHE2_OUTPUT_FILE
        echo -e $APACHE2_SITEFILE_LINE7 >> $APACHE2_OUTPUT_FILE
        echo -e $APACHE2_SITEFILE_LASTLINE >> $APACHE2_OUTPUT_FILE
        
        a2ensite $SITE_NAME
      fi
    fi
  else
    echo No site argument provided.
  fi
fi

exit 0
