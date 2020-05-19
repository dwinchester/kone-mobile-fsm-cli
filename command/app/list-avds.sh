#!/bin/sh

set -e
. "${ROOT_DIR}/utils.sh"

help_arg=2
if [ "${!help_arg}" == "help" ]; then
  say "Usage: kone app list-avds"  
  exit 3
fi

cd "${HOME}/${ANDROID_HOME}/emulator"

echo "List of virtual devices"

# get a list of AVD names, execute emulator -list-avds
emulator -list-avds
exit 0