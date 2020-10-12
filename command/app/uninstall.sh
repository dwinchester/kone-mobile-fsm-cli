#!/bin/sh

set -e
. "${ROOT_DIR}/utils/utils.sh"

show_help() {
  echo ""
  echo "Usage: kone app uninstall [options] [[--] <additional arguments>]]"
  echo ""
  echo "Options:"
  echo "  -h, --help                      Show command line help." 
  echo "  --device <DEVICE_ID>            The ID of the connected device."
  echo "  --package <PACKAGE_NAME>        The name of the package to uninstall."
  echo ""
  echo "Examples:"
  echo "  kone app uninstall"    
  echo "  kone app uninstall --device ZY32298W3J"
  echo "  kone app uninstall --package com.salesforce.fieldservice.app.kone"
  echo "  kone app uninstall --device emulator-5556 --package com.salesforce.fieldservice.app.kone"
  echo ""
}

device="${DEVICE_ID}"
pkg="${PACKAGE_NAME}"

while [ $# -ne 0 ]
do
  key="${1}" 
  case "${key}" in
    -h|--help|help)
      show_help
      exit 3
      ;;
    uninstall)
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

cd "${ANDROID_HOME}/platform-tools"

# get all third-party installed packages and filter to find the specified package 
exists=$( ./adb -s "${device}" shell pm list packages -3 | grep ${pkg} )

if [ "${exists}" = "package:${pkg}" ]; then
  # remove the package from the device
  ./adb -s "${device}" uninstall "${pkg}" >/dev/null
  say "${green:-}Success${normal:-} App uninstalled from ${device}."
  exit 0
fi

say_warning "Package ${pkg} not installed on device. Exiting with code 0."
exit 0