#!/bin/sh

set -e
. "${ROOT_DIR}/utils.sh"

show_help() {
  echo ""
  echo "Description: Run a package on a device."   
  echo "Usage: kone app run [options]"
  echo ""
  echo "Options:"
  echo "  -h, --help                Show command line help."  
  echo "  --device <DEVICE_ID>      The name of the device."
  echo ""
  echo "Examples:"
  echo "  kone app run --help"
  echo "  kone app run"
  echo "  kone app run --device ZY32298W3J"
  echo "" 
}

device="${DEVICE_ID}"

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
    --device)
      shift
      device="${1}"
      ;;
    *)
      say_err "$(unknown_command_message "${key}")"
      exit 3
      ;;
  esac
  shift
done

cd "${HOME}/${ANDROID_HOME}/platform-tools"

say "Starting KONE FSM app."
# start the app package with the component name as defined in the manifest
adb -s "${device}" shell am start -n "${PACKAGE_NAME}/com.salesforce.fieldservice.app.ui.launcher.FieldServicePrerequisiteActivity"
exit 0