#!/bin/bash

# This is a script to start Bundy on Docker

sudo docker run -d --name bundy_db -p 3306:3306 -v /etc/localtime:/etc/localtime:ro bundy_db

sleep 10

sudo docker run -d --name bundy_inv -v /etc/localtime:/etc/localtime:ro bundy_inv

sleep 10

sudo docker run -d --name bundy_ful --link bundy_db:bundy_db -v /etc/localtime:/etc/localtime:ro bundy_ful

sleep 10

sudo docker run -d --name bundy_web -p 80:80 --link bundy_db:bundy_db --link bundy_ful:bundy_ful --link bundy_inv:bundy_inv -v /etc/localtime:/etc/localtime:ro bundy_web

exit 0