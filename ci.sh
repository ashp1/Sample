#!/usr/bin/env bash

image="bonita-ci-docker-image"
name='bonita-ci'

if [ ! -f "${image}.tar" ]
then
    wget https://customer.bonitasoft.com/system/files/support-policies/knowledge_base/showcases/${image}.tar
fi

if ! docker images | grep $image
then
    docker load --input ${image}.tar
fi

if docker ps -a | grep $name
then
    docker rm -f $name
fi

target=$(pwd)/studio-binaries
mkdir -p $target

#adjust to your source tree from s3
cp ~/Downloads/BonitaBPMSubscription-7.2.3.zip $target/

#change the -ti to -d for background
docker run -ti \
    --name $name \
    -p 8888:8080 \
    -v $target:/opt/studio-binaries \
    -m 2g \
    -e "JAVA_OPTS=-Xmx1896m" \
    $image


