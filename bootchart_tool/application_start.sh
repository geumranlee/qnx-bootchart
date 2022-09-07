#!/bin/ksh

echo "Run late services"

#slm -s m_late_service /etc/slm-config.xml &
#slmctl "start m_late_service"

chmod 777 /usr_data/

# Change log directory owner/permission 
cd /log
find . -group root -exec chown 0:1000 {} \;
find . -perm 640 -exec chmod 660 {} \;

echo "Start bootchart"
cd /usr_data/bootchart_tool
on -p 40r ./bootchartd

cd /log
