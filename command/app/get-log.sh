#!/bin/sh

set -e
. "${ROOT_DIR}/utils.sh"

show_help() {
  echo ""
  echo "Usage: kone app get-log [options] [[--] <additional arguments>]]"
  echo ""
  echo "Options:"
  echo "  -h, --help                      Show command line help." 
  echo "  --device <DEVICE_ID>            The ID of the connected device."
  echo "  --file-name <FILE_NAME>         The name of the file that logs are written to."
  echo "  --format <FORMAT>               The format options for the command. Default is threadtime."
  echo "  --path <LOGS_PATH>              The directory that log files are written to. The default is the configured logs path."
  echo "  --remove-old                    Removes all old log files before a new log file is created."
  echo "  --all-logs                      Prints out all logcat logs."
  echo ""
  echo "Examples:"
  echo "  kone app get-log" 
  echo "  kone app get-log --remove-old "          
  echo "  kone app get-log --device ZY32298W3J"
  echo "  kone app get-log --path /Users/lwinchester/Desktop/Logs"
  echo "  kone app get-log --file-name whatever.log --path /Users/lwinchester/Desktop/Logs"
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
logs_path="${LOGGING_FILES_PATH}"
pkg="${PACKAGE_NAME}"
remove_logs=false
no_pkg=false

# the name of the file that logs are written to; e.g. android-debug-202005191027.log
now="$( date +"%Y%m%d%I%M" )"
file_name="android-debug-${now}.log"

while [ $# -ne 0 ]
do
  key="${1}" 
  case "${key}" in
    -h|--help|help)
      show_help
      exit 3
      ;;
    get-log)
      ;;  
    --device)
      shift
      device="${1}"
      ;;
    --file-name)
      shift
      file_name="${1}"
      ;;
    --format)
      shift
      format="${1}"
      ;;
    --remove-old)
      remove_logs=true
      ;;
    --package)
      shift
      pkg="${1}"
      ;;
    --path)
      shift
      logs_path="${1}"
      ;;
    --all-logs)
      no_pkg=true
      ;;
    *)
      say_err "$(unknown_command_message "${key}")"
      exit 3
      ;;
  esac
  shift
done

# the directory that log files are written to. If set to 'auto', then the location
# is in the CLI root/log directory
if [ "${logs_path}" = "auto" ]; then
  logs_path="${ROOT_DIR}/log"
elif [ ! -d "${logs_path}" ]; then # check that the configured path exists
  say_err "No such directory: ${logs_path}. Exiting with code 1."
  exit 1
fi

# remove all old log files
if [ "${remove_logs}" = true ]; then
  say "Removing old log files from ${logs_path}."
  rm -rfv "${logs_path}"/*
fi


log_file_path="$( combine_paths ${logs_path} ${file_name} )"

cd "${ANDROID_HOME}/platform-tools"

# skip PACKAGE_NAME
if [ "${no_pkg}" = true ]; then
  say "Using full logcat"

  ./adb -s "${device}" logcat -v ${format} -d  > "${log_file_path}"  
  exit 0
fi

./adb -s "${device}" logcat -v ${format} | grep -e "${pkg}" > "${log_file_path}"
exit 0