#!/bin/sh

set -e
. "${ROOT_DIR}/utils/utils.sh"
get_theme

show_help() {
  echo ""
  echo "${COLOR_YELLOW}Creates a new CLI command.${COLOR_NORMAL}"
  echo ""
  echo "${COLOR_DARK_GRAY}VERSION:${COLOR_NORMAL} ${BACKGROUND_BLUE}${CLI_VERSION}${BACKGROUND_NORMAL}"
  echo ""
  echo "${COLOR_DARK_GRAY}USAGE:${COLOR_NORMAL}" 
  echo "${COLOR_GREEN}kone${COLOR_NORMAL} ${COLOR_YELLOW}cli${COLOR_NORMAL} ${COLOR_CYAN}create-command${COLOR_NORMAL} ${COLOR_MAGENTA}[arguments]${COLOR_NORMAL}"       
  echo ""
  echo "${COLOR_DARK_GRAY}ARGUMENTS${COLOR_NORMAL}               ${COLOR_DARK_GRAY}DESCRIPTION:${COLOR_NORMAL}"
  echo "${COLOR_MAGENTA}-h, --help${COLOR_NORMAL}              ${COLOR_LIGHT_GRAY}Show command line help.${COLOR_NORMAL}"
  echo "${COLOR_MAGENTA}-n, --name${COLOR_NORMAL}              ${COLOR_LIGHT_GRAY}The name of the new command.${COLOR_NORMAL}"
  echo "${COLOR_MAGENTA}-o, --option${COLOR_NORMAL}            ${COLOR_LIGHT_GRAY}The name of the new command-option.${COLOR_NORMAL}"
  echo ""
  echo "${COLOR_DARK_GRAY}EXAMPLES:${COLOR_NORMAL}" 
  echo "$ ${COLOR_GREEN}kone${COLOR_NORMAL} ${COLOR_YELLOW}cli${COLOR_NORMAL} ${COLOR_CYAN}create-command${COLOR_NORMAL} ${COLOR_MAGENTA}-n hello --o world${COLOR_NORMAL}"
  echo ""
}

# we do this to prevent the command from create an empty .sh file when no 
# command name is passed to the terminal
if [ $# == 1 ]; then
  show_help # no other options where passed, so show help
  exit 3
fi

while [ $# -ne 0 ]
do
  key="${1}" 
  case "${key}" in
    -h|--help|help)
      show_help
      exit 0
      ;;
    create-command)
      ;;
    -n|--name)
      shift
      command_name="${1}"
      ;;
    -o|--option)
      shift
      command_option="${1}"
      ;;
    *)
      say_err "$(unknown_command_message "${key}")"
      exit 3
      ;;
  esac
  shift
done

cmd_dir="${ROOT_DIR}/command"

# create new command directory
cmd_dir="${cmd_dir}/${command_name}"

if [[ ! -d "${cmd_dir}" ]]; then
  mkdir "${cmd_dir}"
  say "${BACKGROUND_CYAN}TODO:${BACKGROUND_NORMAL} Fill out the help information for this command." > "${cmd_dir}/help.sh" # create help file
fi

# create command-option file
if [[ -f "${cmd_dir}/${command_option}.sh" ]]; then
  say_err "That command already exists. Exiting with code 1."
  exit 1
fi
say "${BACKGROUND_CYAN}TODO:${BACKGROUND_NORMAL} The arguments you wish to provide to this command." > "${cmd_dir}/${command_option}.sh"

chmod -R 775 "${HOME}/.kone/" # update execute permissions

say "${BACKGROUND_GREEN}Success${BACKGROUND_NORMAL} ${COLOR_GREEN}Command '${command_name}' created.${COLOR_NORMAL}"
exit 0