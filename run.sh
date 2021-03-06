#!/bin/bash

# before starting the terracotta server, we update the tc-config.xml configuration file
if [[ -z $OFFHEAP_MAX_SIZE ]]; then
   export OFFHEAP_MAX_SIZE="2g";
fi

if [[ -z $HOSTNAME ]]; then
   export HOSTNAME="terracotta.marathon.mesos";
fi

echo -e "\n127.0.0.1  $HOSTNAME" >> /etc/hosts;
cat /etc/hosts;

sed -i -r 's/OFFHEAP_ENABLED/'$OFFHEAP_ENABLED'/; s/OFFHEAP_MAX_SIZE/'$OFFHEAP_MAX_SIZE'/; s/TC_SERVER1/'$TC_SERVER1'/g; s/TC_SERVER2/'$TC_SERVER2'/; s/MY_HOST/'$HOSTNAME'/g; s/TC_SERVER2/'$TC_SERVER2'/g' config/tc-config*.xml 
cat config/tc-config-active-passive.xml
if [[ -n $TC_SERVER1 ]] || [[ -n $TC_SERVER2 ]]; then
  bin/start-tc-server.sh -f config/tc-config-active-passive.xml -n $HOSTNAME;
else 
  bin/start-tc-server.sh -f config/tc-config-single-node.xml;
fi
