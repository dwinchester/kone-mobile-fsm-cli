#!/bin/sh

set -e
. "${ROOT_DIR}/utils.sh"

# TODO:
# --device, --keep-files, --file-name, --path, --help, --log-level

resolve_logs_path() {

  local logs_path="${LOGGING_FILES_PATH}"

  if [ "${logs_path}" = "auto" ]; then
    logs_path="${ROOT_DIR}/log"
    echo "${logs_path}"
    return 0
  fi 

  echo "${logs_path}"
  return 0
}

device="${DEVICE_ID}"

cd "${HOME}/${ANDROID_HOME}/platform-tools"

now="$( date +"%Y%m%d%I%M" )"

# the name of the file that logs are written to, e.g. android-debug-202005191027.log
log_file_name="android-debug-${now}.log"

# the directory that log files are written to. If set to 'auto', then the location
# is in the CLI root/log dir
logs_dir=$( resolve_logs_path ) 

# create the logs dir if it does not exist
if [ ! -d "${logs_dir}" ]; then
  say_warning "No such directory. Creating logging files path."
  mkdir "${logs_dir}"
  say "${green:-}Success${normal:-} Logging directory created: ${blue:-}${logs_dir}${normal:-}"
fi

log_file_path="$( combine_paths ${logs_dir} ${log_file_name} )"

# clean previous logs

# adb logcat -v threadtime "${device}" > "${log_file_path}"
${ROOT_DIR}/coloredlogcat.py

# logcat() {
#   if [ -z "$1" ]; then
#     say_err "Process Id argument missing."; return
#   fi
#   pid_filter="\b$1\b"
#   pid=$(adb shell ps | egrep $pid_filter | cut -c10-15)

#   if [ -z "${pid}" ]; then
#     say_err "Process $1 is not running."; return
#   fi
#   adb logcat | grep $pid
# }

# logcat "${PACKAGE_NAME}"

# adb logcat -v brief | grep -e "${PACKAGE_NAME}"

exit 0