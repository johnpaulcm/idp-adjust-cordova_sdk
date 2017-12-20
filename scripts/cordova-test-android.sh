#!/usr/bin/env bash

# Exit if any errors occur

# set -e

# Get the current directory (/scripts/ directory)
SCRIPTS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Traverse up to get to the root directory
ROOT_DIR="$(dirname "$SCRIPTS_DIR")"
PLUGIN_DIR=plugin
EXAMPLE_DIR=example
SDK_NAME=com.adjust.sdk

RED='\033[0;31m' 	# Red color
GREEN='\033[0;32m' 	# Green color
NC='\033[0m' 		# No Color

#echo -e "${GREEN}>>> Updating git submodules ${NC}"
#cd ${ROOT_DIR}
#git submodule update --init --recursive

echo -e "${GREEN}>>> Removing app from test device ${NC}"
adb uninstall com.adjust.examples

echo -e "${GREEN}>>> Running Android build script ${NC}"
cd ${ROOT_DIR}
ext/Android/build.sh release

echo -e "${GREEN}>>> Installing Android platform ${NC}"
cd ${ROOT_DIR}/${EXAMPLE_DIR}
cordova platform add android

echo -e "${GREEN}>>> Re-installing plugins ${NC}"
cordova plugin remove ${SDK_NAME}

cordova plugin add ../${PLUGIN_DIR}
cordova plugin add cordova-plugin-console
cordova plugin add cordova-plugin-customurlscheme --variable URL_SCHEME=adjustExample
cordova plugin add cordova-plugin-dialogs
cordova plugin add cordova-plugin-whitelist
cordova plugin add https://github.com/apache/cordova-plugin-device.git
cordova plugin add cordova-universal-links-plugin

cordova build android
echo -e "${GREEN}>>> Build successful. APK generated ${NC}"
#echo -e "${GREEN}>>> Build successful. Installing APK on device ${NC}"

#cordova run android --device --nobuild
