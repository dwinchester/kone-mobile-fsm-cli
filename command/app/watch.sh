#!/bin/sh

set -e
. "${ROOT_DIR}/utils/utils.sh"

show_help() {
  echo ""
  echo "Usage: kone app watch [options] [[--] <additional arguments>]]"
  echo ""
  echo "Options:"
  echo "  -h, --help                      Show command line help." 
  echo "  --device <DEVICE_ID>            The ID of the connected device."
  echo "  --format <FORMAT>               The format options for the command. Default is threadtime."
  echo "  --package <PACKAGE>             The name of the package to monitor."
  echo ""
  echo "Examples:"
  echo "  kone app watch"    
  echo "  kone app watch --device ZY32298W3J"
  echo ""
  echo "Format-options:"
  echo "  brief - Display priority, tag, and PID of the process issuing the message."
  echo "  long - Display all metadata fields and separate messages with blank lines."
  echo "  process - Display PID only."
  echo "  raw - Display the raw log message with no other metadata fields."
  echo "  tag - Display the priority and tag only."
  echo "  thread - A legacy format that shows priority, PID, and TID of the thread issuing the message."
  echo "  threadtime - Display the date, invocation time, priority, tag, PID, and TID of the thread issuing the message."
  echo "  time - Display the date, invocation time, priority, tag, and PID of the process issuing the message."
  echo ""
}

device="${DEVICE_ID}"
format="threadtime"
pkg="${PACKAGE_NAME}"

while [ $# -ne 0 ]
do
  key="${1}" 
  case "${key}" in
    -h|--help|help)
      show_help
      exit 3
      ;;
    watch)
      ;;
    --device)
      shift
      device="${1}"
      ;;
    --format)
      shift
      format="${1}"
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

./adb -s "${device}" logcat -v ${format} | grep -e "${pkg}"
exit 0