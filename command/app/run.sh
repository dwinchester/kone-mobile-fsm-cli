#!/bin/sh

set -e
. "${ROOT_DIR}/utils.sh"

cd "${HOME}/${ANDROID_HOME}/platform-tools"
say "Starting KONE FSM app"

# start the app package with the component name as defined in the manifest
adb shell am start -n "${PACKAGE_NAME}/com.salesforce.fieldservice.app.ui.launcher.FieldServicePrerequisiteActivity"
exit 0