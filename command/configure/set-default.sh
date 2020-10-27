#!/bin/sh

set -e
. "${ROOT_DIR}/utils/utils.sh"

show_help() {
  echo ""
  echo "${COLOR_YELLOW}Sets a profile as the default config file.${COLOR_NORMAL}"
  echo ""
  echo "${COLOR_DARK_GRAY}VERSION:${COLOR_NORMAL} ${BACKGROUND_BLUE}${CLI_VERSION}${BACKGROUND_NORMAL}"
  echo ""
  echo "${COLOR_DARK_GRAY}USAGE:${COLOR_NORMAL}" 
  echo "${COLOR_GREEN}kone${COLOR_NORMAL} ${COLOR_YELLOW}configure${COLOR_NORMAL} ${COLOR_CYAN}set-default${COLOR_NORMAL} ${COLOR_MAGENTA}[arguments]${COLOR_NORMAL}"       
  echo ""
  echo "${COLOR_DARK_GRAY}ARGUMENTS${COLOR_NORMAL}                    ${COLOR_DARK_GRAY}DESCRIPTION:${COLOR_NORMAL}"
  echo "${COLOR_MAGENTA}-h, --help${COLOR_NORMAL}                   ${COLOR_LIGHT_GRAY}Show command line help.${COLOR_NORMAL}"    
  echo "${COLOR_MAGENTA}-p, --profile <PROFILE>${COLOR_NORMAL}      ${COLOR_LIGHT_GRAY}Specifies the named profile to use for this command.${COLOR_NORMAL}"    
  echo ""
  echo "${COLOR_DARK_GRAY}EXAMPLES:${COLOR_NORMAL}" 
  echo "$ ${COLOR_GREEN}kone${COLOR_NORMAL} ${COLOR_YELLOW}configure${COLOR_NORMAL} ${COLOR_CYAN}set-default${COLOR_NORMAL} ${COLOR_MAGENTA}--profile android${COLOR_NORMAL}"
  echo ""
}

set_config() {
  eval $invocation

  sed -i '' "s/\($(to_upper $1) *= *\).*/\1$2/" "${3}"

  return 0
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
    set-default)
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

# we need to check that the profile exists
if [ ! -f "${config_file}" ]; then
  say_err "No such profile found: ${profile}"
  exit 0
fi

# updates the cli settings value to use the specified named profile
set_config "default_profile" "config\/${profile}.settings" "${ROOT_DIR}/cli.settings"

say "${BACKGROUND_GREEN}Success${BACKGROUND_NORMAL} ${COLOR_GREEN}Profile '${profile}' set to default.${COLOR_NORMAL}"
exit 0