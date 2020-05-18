#!/bin/sh

set -e
. "${ROOT_DIR}/utils.sh"

cd "${HOME}/${ANDROID_HOME}/platform-tools"
say "Uninstalling KONE FSM app"

# remove the app package from the device
adb uninstall "${PACKAGE_NAME}"
exit 0