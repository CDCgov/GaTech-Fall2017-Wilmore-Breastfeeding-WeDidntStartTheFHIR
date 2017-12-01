#!/bin/sh
cp /root/portal/portal.war /var/lib/jetty/webapps/portal.war
/docker-entrypoint.sh &
sleep 150

/bin/bash /root/addpatients.sh

sleep 360000
