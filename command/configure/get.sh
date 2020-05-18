#!/bin/sh

set -e
. "${ROOT_DIR}/utils.sh"

show_help() {
  echo ""
  echo "Description: Get a configuration value from the config file."   
  echo "Usage: kone configure get [options]"
  echo ""
  echo "Options:"
  echo "  -h, --help                Show command line help."  
  echo "  --profile <PROFILE>       Specifies the named profile to use for this command."   
  echo "  --variable <VARNAME>      The name of the config value to retrieve."
  echo ""
}

is_not_empty() {
  eval $invocation

  local input="${1}"

  if [ -z "${input}" ]; then
    say_err "Variable value cannot be blank.\nPlease see the project wiki for supported options: https://github.com/konecorp/kone-mobile-fsm-android/wiki/CLI:-configure-get-command."
    exit 1
  fi
  return 0
}

while [ $# -ne 0 ]
do
  key="${1}" 
  case "${key}" in
    -h|--help|help)
      show_help
      exit 3
      ;;
    get)
      ;;
    --profile)
      shift
      profile="${1}"
      ;;
    --variable)
      shift
      varname="$(to_upper ${1})" # all profile values are uppercase
      ;; 
    *)
      say_err "$(unknown_command_message "${key}")"
      exit 3
      ;;
  esac
  shift
done

is_not_empty "${varname}"

config_file="$(resolve_profile_path ${profile})"
source "${config_file}"

say "${!varname}"
exit 0