#!/bin/sh

set -e
. "${ROOT_DIR}/utils.sh"

help_arg=2
if [ "${!help_arg}" == "help" ]; then
  say "Usage: kone app list-devices"  
  exit 3
fi

cd "${HOME}/${ANDROID_HOME}/platform-tools"

# list all AVD names that are connected to the adb server
adb devices -l
exit 0