#!/bin/sh

set -e
. "${ROOT_DIR}/utils/utils.sh"

show_help() {
  echo ""
  echo "Usage: kone app list-packages [options] [[--] <additional arguments>]]"
  echo ""
  echo "Options:"
  echo "  -h, --help                Show command line help."  
  echo "  --device <DEVICE_ID>      The ID of the connected device."  
  echo "  --enabled                 Print only enabled packages." 
  echo "  --system                  Print only system packages." 
  echo "  --third-party             Print only 3rd party (or non-system) packages."
  echo "  --uninstalled             Include uninstalled packages."
  echo ""
  echo "Examples:"
  echo "  kone app list-packages --help"
  echo "  kone app list-packages"
  echo "  kone app list-packages --device ZY32298W3J"
  echo "  kone app list-packages --third-party"
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
    list-packages)
      ;;
    --device)
      shift
      device="${1}"
      ;;
    --enabled)
      non_dynamic_params+=" -e"
      ;; 
    --system)
      non_dynamic_params+=" -s"
      ;; 
    --third-party)
      non_dynamic_params+=" -3"
      ;; 
    --uninstalled)
      non_dynamic_params+=" -u"
      ;; 
    *)
      say_err "$(unknown_command_message "${key}")"
      exit 3
      ;;
  esac
  shift
done

cd "${ANDROID_HOME}/platform-tools"

echo "List of packages"

./adb -s "${device}" shell pm list packages ${non_dynamic_params}
exit 0