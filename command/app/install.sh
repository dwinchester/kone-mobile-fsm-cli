#!/bin/sh

set -e
. "${ROOT_DIR}/utils.sh"

show_help() {
  echo ""
  echo "Description: Installs a package to a device."
  echo "Usage: kone app install [options] [[--] <additional arguments>]]"
  echo ""
  echo "Options:"
  echo "  -h, --help      Show command line help."     
  echo "  --device        The device ID from the output of kone app list-devices command."
  echo "  --reinstall     Reinstall an existing app, keeping its data." 
  echo ""
  echo "Examples:"
  echo "  kone app install"      
  echo "  kone app install --device ZY32298W3J"
  echo "  kone app install --device ZY32298W3J --reinstall"
  echo ""
}

device="${DEVICE_ID}"
non_dynamic_params=""

while [ $# -ne 0 ]
do
  key="${1}" 
  case "${key}" in
    -h|--help|help)
      show_help
      exit 3
      ;;
    install)
      ;;
    -d|--device)
      shift
      device="${1}"
      ;; 
    -r|--reinstall)
      non_dynamic_params+=" -r"
      ;;
    *)
      say_err "$(unknown_command_message "${key}")"
      exit 3
      ;;
  esac
  shift
done

output_dir="android/FieldService-Android/FieldService-App/build/outputs/apk/qa/release"
apk_path="$(combine_paths $(get_project_path) ${output_dir})"

cd "${HOME}/${ANDROID_HOME}/platform-tools"

say "Installing KONE FSM app to device ID: ${device}"

# if the APK is built using a developer preview SDK, you must include the 
# -t option with the install command to install a test APK
adb -s "${device}" install "${non_dynamic_params}" "${apk_path}/FieldService-App-qa-release.apk"
exit 0