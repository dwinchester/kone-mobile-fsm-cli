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
  echo "  --file-name <FILE_NAME>         "
  echo "  --path <LOGS_PATH>              "
  echo "  --remove-old                    "
  echo ""
  echo "Examples:"
  echo "  kone app install"    
  echo "  kone app install --apk /users/lwinchester/Desktop/apks/FieldService-App-qa-release.apk" 
  echo "  kone app install --build-flavor production --device emulator-5554"       
  echo "  kone app install --device ZY32298W3J"
  echo "  kone app install --reinstall"
  echo ""
}

resolve_logs_path() {
  local 
  
  if [ "${logs_path}" = "auto" ]; then
    logs_path="${ROOT_DIR}/log"
    echo "${logs_path}"
    return 0
  fi 

  echo "${logs_path}"
  return 0
}

device="${DEVICE_ID}"
remove_logs=false
log_level="E"
logs_path="${LOGGING_FILES_PATH}"
pkg="${PACKAGE_NAME}"

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
fi 

# check if the directory exists at the specified path
if [ ! -d "${logs_path}" ]; then
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

adb -s "${device}" logcat -v threadtime | grep -e "${pkg}" > "${log_file_path}"
exit 0