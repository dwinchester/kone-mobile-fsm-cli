#!/bin/sh

set -e
. "${ROOT_DIR}/utils.sh"

cd "${HOME}/${ANDROID_HOME}/platform-tools"
say "Logging system info from KONE FSM app"

# adb -e logcat "${PACKAGE_NAME}"

# dump a log of system messages, including stack traces when the device 
# throws an error or message
adb push "${ROOT_DIR}/logging.sh" "/data/local/tmp/logging.sh"

# we need to give the file execute permissiosn on the device
adb shell "chmod 0777 /data/local/tmp/logging.sh"
adb shell "/data/local/tmp/logging.sh"
