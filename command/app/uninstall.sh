#!/bin/sh

set -e
. "${ROOT_DIR}/utils.sh"

is_app_installed() {
  if adb shell pm list packages | grep ${PACKAGE_NAME}; then
    return 0
  fi
  return 1
}

device="${DEVICE_NAME}"

cd "${HOME}/${ANDROID_HOME}/platform-tools"

if is_app_installed; then
  say "Uninstalling KONE FSM app from device ID: ${device}"

  # remove the app package from the device
  adb uninstall "${PACKAGE_NAME}"
  exit 0
fi

say_warning "App not installed on device ID: ${device}. Exiting with code 0."
exit 0