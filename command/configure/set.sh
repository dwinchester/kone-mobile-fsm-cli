#!/bin/sh

set -e
. "${ROOT_DIR}/utils/utils.sh"

show_help() {
  echo ""
  echo "${COLOR_YELLOW}Set a configuration value from the config file.${COLOR_NORMAL}"
  echo ""
  echo "${COLOR_DARK_GRAY}VERSION:${COLOR_NORMAL} ${BACKGROUND_BLUE}${CLI_VERSION}${BACKGROUND_NORMAL}"
  echo ""
  echo "${COLOR_DARK_GRAY}USAGE:${COLOR_NORMAL}" 
  echo "${COLOR_GREEN}kone${COLOR_NORMAL} ${COLOR_YELLOW}configure${COLOR_NORMAL} ${COLOR_CYAN}set${COLOR_NORMAL} ${COLOR_MAGENTA}[arguments]${COLOR_NORMAL}"       
  echo ""
  echo "${COLOR_DARK_GRAY}ARGUMENTS${COLOR_NORMAL}                         ${COLOR_DARK_GRAY}DESCRIPTION:${COLOR_NORMAL}"
  echo "${COLOR_MAGENTA}-h, --help${COLOR_NORMAL}                        ${COLOR_LIGHT_GRAY}Show command line help.${COLOR_NORMAL}"  
  echo "${COLOR_MAGENTA}-n, --varname <VARNAME>${COLOR_NORMAL}           ${COLOR_LIGHT_GRAY}The name of the config value to set.${COLOR_NORMAL}"
  echo "${COLOR_MAGENTA}-v, --value <VALUE>${COLOR_NORMAL}               ${COLOR_LIGHT_GRAY}The value to be set.${COLOR_NORMAL}"
  echo "${COLOR_MAGENTA}-p, --profile <PROFILE>${COLOR_NORMAL}           ${COLOR_LIGHT_GRAY}Specifies the named profile to use for this command.${COLOR_NORMAL}"   
  echo ""
  echo "${COLOR_DARK_GRAY}EXAMPLES:${COLOR_NORMAL}" 
  echo "$ ${COLOR_GREEN}kone${COLOR_NORMAL} ${COLOR_YELLOW}configure${COLOR_NORMAL} ${COLOR_CYAN}set${COLOR_NORMAL} ${COLOR_MAGENTA}--varname version_tag --value 8.3.1${COLOR_NORMAL}"
  echo "$ ${COLOR_GREEN}kone${COLOR_NORMAL} ${COLOR_YELLOW}configure${COLOR_NORMAL} ${COLOR_CYAN}set${COLOR_NORMAL} ${COLOR_MAGENTA}--varname verbose --value false --profile User1${COLOR_NORMAL}"
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
    -n|--varname)
      shift
      varname="${1}"
      ;;
    -p|--profile)
      shift
      profile="${1}"
      ;;
    -v|--value)
      shift
      value="${1}"
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
  say_err "No such profile found: ${profile}"
  exit 0
fi

# make sure that both the varname and value options include valid params
if [ -z "${varname}" ] || [ -z "${value}" ]; then
  # exit because we need both options, otherwise, a blank value is set
  say_err "Cannot update config settings. Both variable name and value args are required. Exiting with code 1."; 
  exit 1;
fi

set_config "${varname}" "${value}" "${config_file}"
say "${BACKGROUND_GREEN}Success${BACKGROUND_NORMAL} ${COLOR_GREEN}Saved settings file.${COLOR_NORMAL}"
exit 0