#!/bin/sh

set -e
. "${ROOT_DIR}/utils.sh"

cd "${ANDROID_HOME}/platform-tools"

# list all AVD names that are connected to the adb server
adb devices -l
exit 0