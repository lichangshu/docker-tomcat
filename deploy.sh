#!/bin/bash

CURRENT=`pwd`

cd $(dirname $0)
if [ $# != 4 ] ; then
  echo "ERROR ERROR ERROR : $0 app.war app_config_dir deploy_name port"
  exit 1;
fi

DOCKER_NAME=$3
PORT=$4

set -e

TMP="/tmp/docker-template/"
rm -rf $TMP
mkdir $TMP

## 
cp $CURRENT/$1 "$TMP/app.war"
cp -r $CURRENT/$2 "$TMP/config/"
cp Dockerfile "$TMP/Dockerfile"

cd $TMP

TAG_NAME=`date +%Y%m%d-%H%M%S`
/usr/bin/docker build . -t $DOCKER_NAME:$TAG_NAME --build-arg WAR_FILE=app.war --build-arg CONTEXT_PATH=ROOT --build-arg PORT=$PORT
#/usr/bin/docker build . -t $DOCKER_NAME:latest
/usr/bin/docker tag $DOCKER_NAME:$TAG_NAME $DOCKER_NAME:latest

/usr/bin/docker ps | grep $DOCKER_NAME && /usr/bin/docker stop $DOCKER_NAME
/usr/bin/docker ps -a | grep $DOCKER_NAME && /usr/bin/docker rm $DOCKER_NAME
/usr/bin/docker run --net host -d --restart always \
                         --name $DOCKER_NAME \
                         -e PORT=$4 \
                         -v /var/log/$DOCKER_NAME/:/usr/local/tomcat/logs/ \
                         $DOCKER_NAME:$TAG_NAME

rm -rf $TMP

