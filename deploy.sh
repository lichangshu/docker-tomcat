#!/bin/bash

CURRENT=`pwd`

cd $(dirname $0)
if [ $# -lt 4 ] ; then
  echo "ERROR ERROR ERROR : $0 app.war app_config_dir deploy_name port"
  exit 1;
fi

DOCKER_NAME=$3
PORT=$4
CONTEXT_PATH=ROOT

set -e

if [ $# -gt 4 ]; then
  CONTEXT_PATH=$5
fi

TMP="/tmp/docker-template/"
rm -rf $TMP
mkdir $TMP

## 
cp $CURRENT/$1 "$TMP/app.war"
cp -r $CURRENT/$2 "$TMP/config/"
cp Dockerfile "$TMP/Dockerfile"

cd $TMP

TAG_NAME=`date +%Y%m%d-%H%M%S`
sudo /usr/bin/docker build . -t $DOCKER_NAME:$TAG_NAME --build-arg WAR_FILE=app.war --build-arg CONTEXT_PATH=$CONTEXT_PATH --build-arg PORT=$PORT
#/usr/bin/docker build . -t $DOCKER_NAME:latest
sudo /usr/bin/docker tag $DOCKER_NAME:$TAG_NAME $DOCKER_NAME:latest

sudo /usr/bin/docker ps | grep $DOCKER_NAME && sudo /usr/bin/docker stop $DOCKER_NAME
sudo /usr/bin/docker ps -a | grep $DOCKER_NAME && sudo /usr/bin/docker rm $DOCKER_NAME
sudo /usr/bin/docker run -d --net host --restart always -m 3g \
                         --name $DOCKER_NAME \
                         -e PORT=$4 \
                         -v /home/apps/tomcat-logs/$DOCKER_NAME/:/usr/local/tomcat/logs/ \
                         $DOCKER_NAME:$TAG_NAME

rm -rf $TMP
