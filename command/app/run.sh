#!/bin/sh

set -e
. "${ROOT_DIR}/utils.sh"

device="${DEVICE_ID}"

cd "${HOME}/${ANDROID_HOME}/platform-tools"

# if the app is not installed, then install it
if ! is_app_installed; then
  say "Package not found. Performing package install."
  "${ROOT_DIR}/command/app/install.sh"
fi

say "Starting KONE FSM app on device ID: ${device}"

# start the app package with the component name as defined in the manifest
adb -s "${device}" shell am start -n "${PACKAGE_NAME}/com.salesforce.fieldservice.app.ui.launcher.FieldServicePrerequisiteActivity"
exit 0