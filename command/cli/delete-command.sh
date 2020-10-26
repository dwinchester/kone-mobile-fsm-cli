#!/bin/sh

set -e
. "${ROOT_DIR}/utils/utils.sh"

show_help() {
  echo ""
  echo "${COLOR_YELLOW}Delete a CLI command directory.${COLOR_NORMAL}"
  echo ""
  echo "${COLOR_DARK_GRAY}VERSION:${COLOR_NORMAL} ${BACKGROUND_BLUE}${CLI_VERSION}${BACKGROUND_NORMAL}"
  echo ""
  echo "${COLOR_DARK_GRAY}USAGE:${COLOR_NORMAL}" 
  echo "${COLOR_GREEN}kone${COLOR_NORMAL} ${COLOR_YELLOW}cli${COLOR_NORMAL} ${COLOR_CYAN}delete-command${COLOR_NORMAL} ${COLOR_MAGENTA}[arguments]${COLOR_NORMAL}"       
  echo ""
  echo "${COLOR_DARK_GRAY}ARGUMENTS${COLOR_NORMAL}               ${COLOR_DARK_GRAY}DESCRIPTION:${COLOR_NORMAL}"
  echo "${COLOR_MAGENTA}-h, --help${COLOR_NORMAL}              ${COLOR_LIGHT_GRAY}Show command line help.${COLOR_NORMAL}"
  echo "${COLOR_MAGENTA}-n, --name${COLOR_NORMAL}              ${COLOR_LIGHT_GRAY}The name of the command to delete.${COLOR_NORMAL}"
  echo ""
  echo "${COLOR_DARK_GRAY}EXAMPLES:${COLOR_NORMAL}" 
  echo "$ ${COLOR_GREEN}kone${COLOR_NORMAL} ${COLOR_YELLOW}cli${COLOR_NORMAL} ${COLOR_CYAN}delete-command${COLOR_NORMAL} ${COLOR_MAGENTA}--name hello${COLOR_NORMAL}"
  echo ""  
}

if [ $# == 1 ]; then
  show_help
  exit 3
fi

while [ $# -ne 0 ]
do
  key="${1}" 
  case "${key}" in
    -h|--help|help)
      show_help
      exit 3
      ;;
    delete-command)
      ;;
    -n|--name)
      shift
      command_name="${1}"
      ;;
    *)
      say_err "$(unknown_command_message "${key}")"
      exit 1
      ;;
  esac
  shift
done

cmd_dir="${ROOT_DIR}/command/${command_name}"
if [[ ! -d "${cmd_dir}" ]]; then
  exit 0
fi

# remove the directory and all its contents
rm -rf "${cmd_dir}"

say "${BACKGROUND_GREEN}Success${BACKGROUND_NORMAL} ${COLOR_GREEN}Command '${command_name}' has been deleted.${COLOR_NORMAL}"
exit 0