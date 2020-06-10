#!/bin/sh

set -e
. "${ROOT_DIR}/utils.sh"

show_help() {
  echo ""
  echo "Description: Builds the package and its dependencies before running the package on a device."   
  echo "Usage: kone app run [options]"
  echo ""
  echo "Options:"
  echo "  -h, --help                      Show command line help."  
  echo "  --device <DEVICE_ID>            The ID of the connected device."
  echo "  --no-build                      Doesn't build the project before running. It also implicitly sets the --no-restore flag."
  echo "  --no-dependencies               Doesn't execute an implicit restore on the project dependencies when running the command."
  echo "  --output <OUTPUT_DIRECTORY>     Specifies the path for the output directory."
  echo "  --profile <PROFILE>             Specifies the named profile to use for this command."
  echo "  --verbosity <LEVEL>             Sets the verbosity level of the command. Allowed values are q[uiet], m[inimal], n[ormal], d[etailed], and diag[nostic]. The default value is m."
  echo ""
  echo "Examples:"
  echo "  kone app run --help"
  echo "  kone app run"
  echo "  kone app run --device ZY32298W3J"
  echo "" 
}

device="${DEVICE_ID}"
no_build=false
no_dependencies=false
profile="default"

while [ $# -ne 0 ]
do
  key="${1}" 
  case "${key}" in
    -h|--help|help)
      show_help
      exit 3
      ;;
    run)
      ;;
    --device)
      shift
      device="${1}"
      ;;
    --no-build)
      no_build=true
      ;;
    --no-dependencies)
      no_dependencies=true
      ;;
    --profile)
      shift
      profile=="${1}"
      ;;
    *)
      say_err "$(unknown_command_message "${key}")"
      exit 3
      ;;
  esac
  shift
done

cd "${HOME}/${ANDROID_HOME}/platform-tools"

say "Starting KONE FSM app."
# start the app package with the component name as defined in the manifest
adb -s "${device}" shell am start -n "${PACKAGE_NAME}/com.salesforce.fieldservice.app.ui.launcher.FieldServicePrerequisiteActivity"
exit 0