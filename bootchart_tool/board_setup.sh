#!/bin/sh

mount -o remount,rw /

setup()
{
	echo "copy application_start.sh to /usr/local"

	if [ ! -e /usr/local/application_start.sh.orig ]; then
		cp /usr/local/application_start.sh{,.orig}
	fi

	cp /usr_data/bootchart_tool/application_start.sh /usr/local
	chmod +x /usr/local/application_start.sh
}

restore()
{
	echo "restore application_start.sh"
	cp /usr/local/application_start.sh.orig /usr/local/application_start.sh
	chmod +x /usr/local/application_start.sh
}

case "$1" in
       "restore")
               restore
               ;;
       *)
               setup
               ;;
esac
