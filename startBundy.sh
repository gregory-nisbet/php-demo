#!/bin/bash

# This is a script to start Bundy on Docker

# Set variables
CONTR_HOST=
CONTR_PORT=8090
EUM_KEY=
echo "${CONTR_HOST} is the controller name and ${CONTR_PORT} is the controller port"

# Pull images
#docker pull appdynamics/bundy_base:latest
#docker pull appdynamics/bundy_db:latest
#docker pull appdynamics/bundy_mem:latest
#docker pull appdynamics/bundy_inv:latest
#docker pull appdynamics/bundy_ful:latest
#docker pull appdynamics/bundy_web:latest

# Start containers 
sudo docker run -d --name bundy_db -p 3306:3306 -v /etc/localtime:/etc/localtime:ro appdynamics/bundy_db:latest

sleep 10

sudo docker run -d --name bundy_mem -p 11211:11211 -v /etc/localtime:/etc/localtime:ro appdynamics/bundy_mem:latest

sleep 10

sudo docker run -d --name bundy_inv -e CONTROLLER=${CONTR_HOST} -e APPD_PORT=${CONTR_PORT} --link bundy_mem:bundy_mem -v /etc/localtime:/etc/localtime:ro appdynamics/bundy_inv:latest

sleep 10

sudo docker run -d --name bundy_ful -e CONTROLLER=${CONTR_HOST} -e APPD_PORT=${CONTR_PORT} --link bundy_db:bundy_db --link bundy_mem:bundy_mem -v /etc/localtime:/etc/localtime:ro appdynamics/bundy_ful:latest

sleep 10

sudo docker run -d --name bundy_web -e CONTROLLER=${CONTR_HOST} -e APPD_PORT=${CONTR_PORT} -e EUM_KEY=${EUM_KEY} -p 80:80 --link bundy_db:bundy_db --link bundy_mem:bundy_mem --link bundy_ful:bundy_ful --link bundy_inv:bundy_inv -v /etc/localtime:/etc/localtime:ro appdynamics/bundy_web:latest

sleep 10

# Install adrum.js if present

if [ -e '/root/adrum.js' ]; then
        echo "Copying adrum.js to /var/www/html/demoapp/Symfony/web/js/adrum.js in bundy_web container"
        docker exec -i bundy_web bash -c 'cat > /var/www/html/demoapp/Symfony/web/js/adrum.js' < adrum.js
        docker exec -i bundy_web bash -c 'chown appdynamics.appdynamics /var/www/html/demoapp/Symfony/web/js/adrum.js' 
else
        echo "No adrum.js present"
fi      

exit 0
