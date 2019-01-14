#!/bin/bash

# before starting the terracotta server, we update the tc-config.xml configuration file
sed -i -r 's/OFFHEAP_ENABLED/'$OFFHEAP_ENABLED'/; s/OFFHEAP_MAX_SIZE/'$OFFHEAP_MAX_SIZE'/; s/TC_SERVER1/'$TC_SERVER1'/g; s/TC_SERVER2/'$TC_SERVER2'/g' config/tc-config*.xml 

if [[ -n $TC_SERVER1 ]] || [[ -n $TC_SERVER2 ]]; then 
  echo "$HOST  $TC_SERVER1" >> /etc/hosts; 
  export HOSTNAME=$TC_SERVER1; 
  sleep 120; 
  bin/start-tc-server.sh -f config/tc-config-active-passive.xml -n $HOSTNAME; 
else 
  echo "127.0.0.1 terracotta.marathon.mesos" >> /etc/hosts
  bin/start-tc-server.sh -f config/tc-config-single-node.xml; 
fi
