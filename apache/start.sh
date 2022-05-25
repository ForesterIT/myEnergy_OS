#!/usr/bin/env bash

peer_template=/usr/src/snmpd.conf
server_conf_path="/etc/snmp/snmpd.conf"

cp "/etc/snmp/snmpd.conf" "/etc/snmp/snmpd.conf.orig"
# substitute env vars in peer template conf
export SNMP_RO_COMMUNITY SNMP_LOCATION SNMP_CONTACT
envsubst < "${peer_template}" > "${server_conf_path}"
service snmpd restart 

apachectl start

# https://raymondjdouglas.com/blog/2018/ups-monitoring/
# https://github.com/Cacti/spine/issues/74
cp "/usr/src/upsd.conf" "/etc/nut/upsd.conf"
cp "/usr/src/nut.conf" "/etc/nut/nut.conf"

upsdrvctl start

while : ; do
  sleep 120
done
