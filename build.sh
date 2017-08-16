#!/bin/bash -x

### ENV VARS ###
BUILD_DIR="/tmp/docker-jeedom-rpi-builddir-$$"
TMP_DIR="/tmp/docker-jeedom-rpi-tmpdir-$$"
TAG="sboyron/jeedom-rpi"
BASE_IMAGE="resin/rpi-raspbian"
URL_JEEDOM_ZIP_STABLE="https://codeload.github.com/jeedom/core/zip/stable"
URL_JEEDOM_DOCKERFILE="https://raw.githubusercontent.com/jeedom/core/beta/Dockerfile"
# clean
mkdir -p $BUILD_DIR $TMP_DIR
trap "rm -rf ${BUILD_DIR} ${TMP_DIR}" EXIT TERM INT

### MAIN ###

# prepare
curl $URL_JEEDOM_ZIP_STABLE -o $TMP_DIR/jeedom.zip
unzip -o ${TMP_DIR}/jeedom.zip -d ${TMP_DIR}
mv ${TMP_DIR}/core-stable/* ${BUILD_DIR}

curl $URL_JEEDOM_DOCKERFILE -o ${BUILD_DIR}/Dockerfile
sed -i "s|FROM.*|FROM $BASE_IMAGE|" ${BUILD_DIR}/Dockerfile

ls -lah $BUILD_DIR
docker build -t $TAG $BUILD_DIR
