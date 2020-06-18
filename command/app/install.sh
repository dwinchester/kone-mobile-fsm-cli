#!/bin/sh

set -e
. "${ROOT_DIR}/utils.sh"

show_help() {
  echo ""
  echo "Usage: kone app install [options] [[--] <additional arguments>]]"
  echo ""
  echo "Options:"
  echo "  -h, --help                      Show command line help." 
  echo "  --apk <PATH>                    Specifies the path of the APK file to install."
  echo "  --build-flavor <FLAVOR>         The version of the app that you want to install. Options are 'qa' or 'production'."    
  echo "  --device <DEVICE_ID>            The ID of the connected device."
  echo "  --reinstall                     Reinstall an existing app, keeping its data." 
  echo "  --standalone                    Specifies whether to ignore the default APK output directory, and uses the APK_PATH setting from the configured profile." 
  echo ""
  echo "Examples:"
  echo "  kone app install"    
  echo "  kone app install --apk /users/lwinchester/Desktop/apks/FieldService-App-qa-release.apk" 
  echo "  kone app install --build-flavor production --device emulator-5554"       
  echo "  kone app install --device ZY32298W3J"
  echo "  kone app install --reinstall"
  echo ""
}

# resolve the default APK directory and file path
get_apk_path() {
  local build_flavor="${1}"

  # is the build flavor set; if not, then set default
  [ -z "${build_flavor}" ] && build_flavor="qa"
  
  output_dir="android/FieldService-Android/FieldService-App/build/outputs/apk/${build_flavor}/release"
  package_name="FieldService-App-${build_flavor}-release.apk"
  apk_path="$( combine_paths $( get_project_path ) $( combine_paths "${output_dir}" "${package_name}" ) )"
  return 0
}

device="${DEVICE_ID}"
non_dynamic_params=""

get_apk_path

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
    --apk)
      shift
      apk_path="${1}"
      ;; 
    --build-flavor)
      shift
      get_apk_path "${1}"
      ;;  
    --device)
      shift
      device="${1}"
      ;;   
    --reinstall)
      non_dynamic_params+=" -r"
      ;;
    --standalone)
      apk_path="${APK_PATH}"
      ;;
    *)
      say_err "$(unknown_command_message "${key}")"
      exit 3
      ;;
  esac
  shift
done

# check if the APK file exists at the specified path
if [ ! -f "${apk_path}" ]; then
  say_err "No such file: ${apk_path}. APK not found. Exiting with code 1."
  exit 1
fi

cd "${ANDROID_HOME}/platform-tools"

say "Performing install. Please wait."

# if the APK is built using a developer preview SDK, you must include the 
# -t option with the install command to install a test APK
./adb -s "${device}" install ${non_dynamic_params} "${apk_path}" >/dev/null
say "${green:-}Success${normal:-} App installed on ${device}."
exit 0