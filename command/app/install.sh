#!/bin/sh

set -e
. "${ROOT_DIR}/utils.sh"

show_help() {
  echo ""
  echo "Description: Installs a package to a device."
  echo "Usage: kone app install [options] [[--] <additional arguments>]]"
  echo ""
  echo "Options:"
  echo "  -h, --help                    Show command line help." 
  echo "  --build-type <BUILD_TYPE>     The version of the app that you want to build."    
  echo "  --device <DEVICE_ID>          The ID of the connected device."
  echo "  --profile <PROFILE>           Specifies the named profile to use for this command." 
  echo "  --reinstall                   Reinstall an existing app, keeping its data." 
  echo ""
  echo "Examples:"
  echo "  kone app install"      
  echo "  kone app install --device ZY32298W3J"
  echo "  kone app install --device ZY32298W3J --reinstall"
  echo ""
}

# TODO: Get named profile

profile="default"
build_type="${BUILD_TYPE}"
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
    --device)
      shift
      device="${1}"
      ;;
    --build-type)
      shift
      build_type=="${1}"
      ;;      
    --profile)
      shift
      profile=="${1}"
      ;;
    --reinstall)
      non_dynamic_params+=" -r"
      ;;
    *)
      say_err "$(unknown_command_message "${key}")"
      exit 3
      ;;
  esac
  shift
done

# TODO: Change APK dir based on build type

output_dir="android/FieldService-Android/FieldService-App/build/outputs/apk/qa/release"
apk_path="$(combine_paths $(get_project_path) ${output_dir})"

cd "${ANDROID_HOME}/platform-tools"

say "Performing install. Please wait."

# if the APK is built using a developer preview SDK, you must include the 
# -t option with the install command to install a test APK
adb -s "${device}" install ${non_dynamic_params} "${apk_path}/FieldService-App-qa-release.apk" >/dev/null
say "${green:-}Success${normal:-} App installed."
exit 0