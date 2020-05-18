#!/bin/sh

set -e

cd "${HOME}/${ANDROID_HOME}/platform-tools"

# print all packages
adb shell pm list packages
exit 0