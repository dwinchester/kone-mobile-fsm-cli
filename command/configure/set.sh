#!/bin/sh

set -e
. "${ROOT_DIR}/utils/utils.sh"

show_help() {
  echo ""
  echo "Usage: kone configure set [options]"
  echo ""
  echo "Options:"
  echo "  -h, --help                        Show command line help."  
  echo "  -s, --setting <SETTING_NAME>      The name of the config value to set."
  echo "  -v, --value <CONFIG_VALUE>        The value to set."
  echo "  -p, --profile <PROFILE>           Specifies the named profile to use for this command."   
  echo ""
  echo "Examples:"
  echo "  kone configure set --help"
  echo "  kone configure set --setting VERSION_TAG --value 1.2.3"
  echo "" 
}

profile="default"

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
    -s|--setting)
      shift
      varname="${1}"
      ;;
    -v|--value)
      shift
      value="${1}"
      ;;
    -p|--profile)
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

config_file="${ROOT_DIR}/config/${profile}.settings"

if [ ! -f "${config_file}" ]; then
  say_warning "Profile '${profile}' not found."
  say "Using default profile: ${blue:-}\`${DEFAULT_PROFILE}\`${normal:-}"

  config_file="${ROOT_DIR}/${DEFAULT_PROFILE}"
fi

# make sure that both the varname and value options include valid params
if [ -z "${varname}" ] || [ -z "${value}" ]; then
  # exit because we need both options, otherwise, a blank value is set
  say_err "Cannot update config settings. Both variable and value options are required. Exiting with code 1."; 
  exit 1;
fi

set_config "${varname}" "${value}" "${config_file}"
say "${BACKGROUND_GREEN}Success${BACKGROUND_NORMAL} ${COLOR_GREEN}Saved settings file.${COLOR_NORMAL}"
exit 0