#!/bin/bash

# This is a startup script for the Bundy Java server

# Add entry to hosts file
sudo echo "127.0.0.1 www.shoewarehouse.com" >> /etc/hosts

# Startup
source /appdynamics/env.sh
su - appdynamics -c "source /appdynamics/env.sh && mv /appdynamics/controller-info.xml ${CATALINA_HOME}/AppServerAgent/${VERSION_STRING}/conf/"
su - appdynamics -c "source /appdynamics/env.sh && sed -i 's#<controller-host></controller-host>#<controller-host>${CONTROLLER}</controller-host>#g' ${CATALINA_HOME}/AppServerAgent/${VERSION_STRING}/conf/controller-info.xml"
su - appdynamics -c "source /appdynamics/env.sh && sed -i 's#<controller-port></controller-port>#<controller-port>${APPD_PORT}</controller-port>#g' ${CATALINA_HOME}/AppServerAgent/${VERSION_STRING}/conf/controller-info.xml"
su - appdynamics -c '/appdynamics/demo/bin/startup.sh'
su - appdynamics -c '/appdynamics/slow/bin/startup.sh'

exit 0
