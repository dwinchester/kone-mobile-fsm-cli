#!/bin/sh

set -e
. "${ROOT_DIR}/utils.sh"

cd "${ANDROID_HOME}/platform-tools"

exists=$(adb shell pm list packages | grep ${PACKAGE_NAME})
if [ "${exists}" = "package:${PACKAGE_NAME}" ]; then
  # remove the app package from the device
  adb uninstall "${PACKAGE_NAME}" >/dev/null
  say "${green:-}Success${normal:-} App uninstalled."
  exit 0
fi

say_warning "App not installed on device. Exiting with code 0."
exit 0