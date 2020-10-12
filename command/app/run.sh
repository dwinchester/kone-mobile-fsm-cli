#!/bin/sh

set -e
. "${ROOT_DIR}/utils/utils.sh"

show_help() {
  echo ""
  echo "Usage: kone app run [options]"
  echo ""
  echo "Options:"
  echo "  -h, --help                      Show command line help."  
  echo "  --debug                         Start the app bundle for remote debugging."
  echo "  --device <DEVICE_ID>            The ID of the connected device."
  echo "  --package <PACKAGE_NAME>        The name of the package to start."
  echo ""
  echo "Examples:"
  echo "  kone app run --help"
  echo "  kone app run"
  echo "  kone app run --debug --package com.salesforce.fieldservice.app.kone"
  echo "  kone app run --device ZY32298W3J"
  echo "" 
}

open_new_tab() {
  eval $invocation

  osascript -e 'tell application "Terminal" to activate' \
    -e 'tell application "System Events" to tell process "Terminal" to keystroke "t" using command down' \
    -e 'tell application "Terminal" to do script "kone app run" in front window'
}

start_app() {
  eval $invocation

  say "Starting device "${device}". Please wait."
  ./adb -s "${device}" shell am start -n "${pkg}/com.salesforce.fieldservice.app.ui.launcher.FieldServicePrerequisiteActivity" >/dev/null
  return 0
}

start_device() {
  eval $invocation

  say_warning "Device ${device} not found. Please start an emulator and then re-run the command."
  source $( combine_paths ${ROOT_DIR} "/command/app/start-device.sh" )
  return 0
}

device="${DEVICE_ID}"
pkg="${PACKAGE_NAME}"
debug=false

while [ $# -ne 0 ]
do
  key="${1}" 
  case "${key}" in
    -h|--help|help)
      show_help
      exit 3
      ;;
    run)
      ;;
    --debug)
      debug=true
      ;;
    --device)
      shift
      device="${1}"
      ;;
    --package)
      shift
      pkg="${1}"
      ;;
    *)
      say_err "$(unknown_command_message "${key}")"
      exit 3
      ;;
  esac
  shift
done

# run the bundle
if [ "${debug}" = true ]; then
  # open a new terminal window and execute the run command without the debug 
  # command-option set
  open_new_tab
  react_path="$( combine_paths $(get_project_path) "/android/React" )"
  cd "${react_path}" && npm start
  exit 0 # exit here
fi

cd "${ANDROID_HOME}/platform-tools"

# determine whether a device is attached to start the app package; otherwise, 
# display a list of emulators and prompt the user to start one 
./adb get-state 1>/dev/null 2>&1 && start_app || start_device

# start the app package with the activity defined in the manifest
start_app
say "${green:-}Success${normal:-} App started."
exit 0