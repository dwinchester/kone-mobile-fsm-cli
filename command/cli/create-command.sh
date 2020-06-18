#!/bin/sh

set -e
. "${ROOT_DIR}/utils.sh"

show_help() {
  echo ""
  echo "Usage: kone cli create-command [options]"
  echo ""
  echo "Options:"
  echo "  -h, --help              Show command line help."
  echo "  -c, --command-name      The name of the new command."
  echo "  -o, --option            The name of the new command-option."
  echo ""
  echo "Examples:"
  echo "  kone cli create-command --help"
  echo "  kone cli create-command --command-name hello --option world"
  echo ""
  echo "Results:"
  echo "  Creates a new command with command-option: 'kone hello world'"
  echo ""   
}

if [ $# == 1 ]; then
  show_help # no other options where passed
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
    -c|--command-name)
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
  say "TODO: Fill out the help information for this command" > "${cmd_dir}/help.sh" # create help file
fi

# create command-option file
if [[ -f "${cmd_dir}/${command_option}.sh" ]]; then
  say_err "That command already exists. Exiting with code 1."
  exit 1
fi
say "TODO: The arguments you wish to provide to this command" > "${cmd_dir}/${command_option}.sh"

chmod -R 775 "${HOME}/.kone/" # update execute permissions

say "${green:-}Success${normal:-} New command created."
exit 0