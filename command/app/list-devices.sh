#!/bin/sh

set -e

cd "${HOME}/${ANDROID_HOME}/platform-tools"

# list all attached devices that are connected to the adb server
adb devices -l
exit 0