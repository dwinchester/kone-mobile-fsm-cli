#!/bin/sh

set -e
. "${ROOT_DIR}/utils.sh"

show_help() {
  echo ""
  echo "Usage: kone app watch-raw [options] [[--] <additional arguments>]]"
  echo ""
  echo "Options:"
  echo "  -h, --help                      Show command line help." 
  echo "  --device <DEVICE_ID>            The ID of the connected device."
  echo "  --log-level <LOG_LEVEL>         The defined log level for messages to be displayed."
  echo "  --package <PACKAGE_NAME>        The name of the package to uninstall."
  echo ""
  echo "Examples:"
  echo "  kone app watch-raw"    
  echo "  kone app watch-raw --device ZY32298W3J --log-level E"
  echo "  kone app watch-raw --package com.salesforce.fieldservice.app.kone"
  echo "  kone app watch-raw --device emulator-5556 --package com.salesforce.fieldservice.app.kone"
  echo ""
  echo "Log-Levels:"
  echo "  V — Verbose"
  echo "  D — Debug (Default)"
  echo "  I — Info"
  echo "  W — Warning"
  echo "  E — Error"
  echo "  F — Fatal"
  echo "  S — Silent"
  echo ""
}

clear=false
device="${DEVICE_ID}"
log_level="D"
pkg="${PACKAGE_NAME}"

while [ $# -ne 0 ]
do
  key="${1}" 
  case "${key}" in
    -h|--help|help)
      show_help
      exit 3
      ;;
    watch-raw)
      ;;
    --device)
      shift
      device="${1}"
      ;;
    --log-level)
      shift
      log_level="${1}"
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

adb -s "${device}" logcat -v brief "${pkg}":"${log_level}"
exit 0