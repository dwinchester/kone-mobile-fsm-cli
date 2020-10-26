#!/bin/sh

set -e
. "${ROOT_DIR}/utils/utils.sh"

show_help() {
  echo ""
  echo "${COLOR_YELLOW}Get a configuration value from the config file.${COLOR_NORMAL}"
  echo ""
  echo "${COLOR_DARK_GRAY}VERSION:${COLOR_NORMAL} ${BACKGROUND_BLUE}${CLI_VERSION}${BACKGROUND_NORMAL}"
  echo ""
  echo "${COLOR_DARK_GRAY}USAGE:${COLOR_NORMAL}" 
  echo "${COLOR_GREEN}kone${COLOR_NORMAL} ${COLOR_YELLOW}configure${COLOR_NORMAL} ${COLOR_CYAN}get${COLOR_NORMAL} ${COLOR_MAGENTA}[arguments]${COLOR_NORMAL}"       
  echo ""
  echo "${COLOR_DARK_GRAY}ARGUMENTS${COLOR_NORMAL}                    ${COLOR_DARK_GRAY}DESCRIPTION:${COLOR_NORMAL}"
  echo "${COLOR_MAGENTA}-h, --help${COLOR_NORMAL}                   ${COLOR_LIGHT_GRAY}Show command line help.${COLOR_NORMAL}"
  echo "${COLOR_MAGENTA}-p, --profile <PROFILE>${COLOR_NORMAL}      ${COLOR_LIGHT_GRAY}Specifies the named profile to use for this command.${COLOR_NORMAL}"
  echo "${COLOR_MAGENTA}-v, --varname <VARNAME>${COLOR_NORMAL}      ${COLOR_LIGHT_GRAY}The name of the config value to retrieve.${COLOR_NORMAL}"

  echo ""
  echo "${COLOR_DARK_GRAY}EXAMPLES:${COLOR_NORMAL}" 
  echo "$ ${COLOR_GREEN}kone${COLOR_NORMAL} ${COLOR_YELLOW}configure${COLOR_NORMAL} ${COLOR_CYAN}get${COLOR_NORMAL} ${COLOR_MAGENTA}--varname apk_path${COLOR_NORMAL}"
  echo "$ ${COLOR_GREEN}kone${COLOR_NORMAL} ${COLOR_YELLOW}configure${COLOR_NORMAL} ${COLOR_CYAN}get${COLOR_NORMAL} ${COLOR_MAGENTA}--varname version_tag --profile release${COLOR_NORMAL}"
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
    get)
      ;;
    -p|--profile)
      shift
      profile="${1}"
      ;;
    -v|--varname)
      shift
      varname="$( to_upper ${1} )" # all profile values are uppercase
      ;; 
    *)
      say_err "$(unknown_command_message "${key}")"
      exit 3
      ;;
  esac
  shift
done

config_file="${ROOT_DIR}/config/${profile}.settings"

if [ ! -f "${config_file}" ]; then
  say_warning "Profile '${profile}' not found."
  say "Using default profile: ${BACKGROUND_BLUE}\`${DEFAULT_PROFILE}\`${BACKGROUND_NORMAL}"

  config_file="${ROOT_DIR}/${DEFAULT_PROFILE}"
fi

if [ -z "${varname}" ]; then
  say_err "Variable value cannot be blank.\nPlease see the project wiki for supported options: https://github.com/konecorp/kone-mobile-fsm-android/wiki/CLI:-configure-get-command."
  exit 1
fi

source "${config_file}"

say "${varname}: ${!varname}"
exit 0