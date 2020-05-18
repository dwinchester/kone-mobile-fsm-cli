#!/bin/sh

set -e
. "${ROOT_DIR}/utils.sh"

show_help() {
  echo ""
  echo "Description: Set a configuration value from the config file."  
  echo "Usage: kone configure set [options]"
  echo ""
  echo "Options:"
  echo "  -h, --help                Show command line help."  
  echo "  --variable <VARNAME>      The name of the config value to set."
  echo "  --value <CONFIG_VALUE>    The value to set."
  echo "  --profile <PROFILE>       Specifies the named profile to use for this command."   
  echo "" 
}

set_config() {
  eval $invocation

  sed -i '' "s/\($(to_upper $1) *= *\).*/\1$2/" "${config_file}"

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
    set)
      ;;
    --variable)
      shift
      varname="${1}"
      ;;
    --value)
      shift
      value="${1}"
      ;;
    --profile)
      shift
      profile="${1}"
      ;;
    *) # unknown option      
      say_err "$(unknown_command_message "${key}")"
      exit 3
      ;;
  esac
  shift
done

config_file="$(resolve_profile_path ${profile})"
source "${config_file}"

set_config "${varname}" "${value}"
say "${green:-}SUCCESS${normal:-}"
exit 0