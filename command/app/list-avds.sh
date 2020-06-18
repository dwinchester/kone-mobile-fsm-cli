#!/bin/sh

set -e
. "${ROOT_DIR}/utils.sh"

cd "${ANDROID_HOME}/emulator"

echo "List of virtual devices"

# get a list of AVD names, execute emulator -list-avds
./emulator -list-avds
exit 0