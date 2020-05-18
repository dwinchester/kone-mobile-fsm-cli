#!/bin/sh

set -e

cd "${HOME}/${ANDROID_HOME}/emulator"

echo "List of virtual devices"

# if unsure of the AVD name, execute emulator -list-avds
emulator -list-avds
exit 0