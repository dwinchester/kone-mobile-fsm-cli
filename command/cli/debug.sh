#!/bin/sh

set -e
. "${ROOT_DIR}/utils/utils.sh"

show_help() {
  echo ""
  echo "${COLOR_YELLOW}Enable or disable the debug flag in the configured profile.${COLOR_NORMAL}"
  echo ""
  echo "${COLOR_DARK_GRAY}VERSION:${COLOR_NORMAL} ${BACKGROUND_BLUE}${CLI_VERSION}${BACKGROUND_NORMAL}"
  echo ""
  echo "${COLOR_DARK_GRAY}USAGE:${COLOR_NORMAL}" 
  echo "${COLOR_GREEN}kone${COLOR_NORMAL} ${COLOR_YELLOW}cli${COLOR_NORMAL} ${COLOR_CYAN}debug${COLOR_NORMAL}"       
  echo ""
  echo "${COLOR_DARK_GRAY}ARGUMENTS${COLOR_NORMAL}      ${COLOR_DARK_GRAY}DESCRIPTION:${COLOR_NORMAL}"
  echo "${COLOR_MAGENTA}-h, --help${COLOR_NORMAL}     ${COLOR_LIGHT_GRAY}Show command line help.${COLOR_NORMAL}"
  echo ""
}

# get the current profile debug value
debug="${DEBUG}"
message=""

while [ $# -ne 0 ]
do
  key="${1}" 
  case "${key}" in
    -h|--help|help)
      show_help
      exit 3
      ;;
    debug)
      ;;
    *)
      say_err "$(unknown_command_message "${key}")"
      exit 1
      ;;
  esac
  shift
done

# toggle the debug flag
if [ "${debug}" = true ]; then
  debug=false
  message="Debug has been disabled."
else 
  debug=true
  message="Debug has been enabled."
fi

# set the debug value in configured profile
"${ROOT_DIR}/command/configure/set.sh" --setting DEBUG --value "${debug}"

say "${BACKGROUND_GREEN}Success${BACKGROUND_NORMAL} ${COLOR_GREEN}${message}${COLOR_NORMAL}"
exit 0