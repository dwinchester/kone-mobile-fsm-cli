#!/bin/sh

set -e
. "${ROOT_DIR}/utils.sh"

show_help() {
  echo ""
  echo "Usage: kone app clear-buffer [options] [[--] <additional arguments>]]"
  echo ""
  echo "Options:"
  echo "  -h, --help                      Show command line help." 
  echo "  --device <DEVICE_ID>            The ID of the connected device."
  echo ""
  echo "Examples:"
  echo "  kone app clear-buffer"          
  echo "  kone app clear-buffer --device ZY32298W3J"
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
    clear-buffer)
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

cd "${ANDROID_HOME}/platform-tools"

# clear the current buffer
adb -s "${device}" logcat -c