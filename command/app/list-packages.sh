#!/bin/sh

set -e
. "${ROOT_DIR}/utils.sh"

show_help() {
  echo ""
  echo "Description: Prints all installed packages on the running device."   
  echo "Usage: kone app list-packages [options] [[--] <additional arguments>]]"
  echo ""
  echo "Options:"
  echo "  -h, --help                Show command line help."  
  echo "  --device <DEVICE_ID>    The name of the device."   
  echo "  --third-party             Print only 3rd party (or non-system) packages."
  echo ""
  echo "Examples:"
  echo "  kone app list-packages --help"
  echo "  kone app list-packages"
  echo "  kone app list-packages --device ZY32298W3J"
  echo "  kone app list-packages --third-party"
  echo "" 
}

device="${DEVICE_ID}"
dynamic_params=""

while [ $# -ne 0 ]
do
  key="${1}" 
  case "${key}" in
    -h|--help|help)
      show_help
      exit 3
      ;;
    list-packages)
      ;;
    --device)
      shift
      device="${1}"
      ;;
    --third-party)
      dynamic_params+=" -3"
      ;; 
    *)
      say_err "$(unknown_command_message "${key}")"
      exit 3
      ;;
  esac
  shift
done

cd "${HOME}/${ANDROID_HOME}/platform-tools"

echo "List of packages"

adb -s "${DEVICE_ID}" shell pm list packages "${dynamic_params}"
exit 0