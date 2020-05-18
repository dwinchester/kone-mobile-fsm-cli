#!/bin/sh

set -e
. "${ROOT_DIR}/utils.sh"

output_dir="android/FieldService-Android/FieldService-App/build/outputs/apk/qa/release"
apk_path="$(combine_paths $(get_project_path) ${output_dir})"

cd "${HOME}/${ANDROID_HOME}/platform-tools"
say "Installing KONE FSM app"

# if the APK is built using a developer preview SDK, you must include the 
# -t option with the install command to install a test APK
adb install "${apk_path}/FieldService-App-qa-release.apk"
exit 0