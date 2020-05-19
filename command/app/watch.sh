#!/bin/sh

set -e

cd "${HOME}/${ANDROID_HOME}/platform-tools"

# ref: http://jsharkey.org/logcat/
# see: https://github.com/jsharkey/android-tools/blob/master/coloredlogcat.py
${ROOT_DIR}/coloredlogcat.py

exit 0
