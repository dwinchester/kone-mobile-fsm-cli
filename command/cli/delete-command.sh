#!/bin/sh

set -e
. "${ROOT_DIR}/utils.sh"

show_help() {
  echo ""
  echo "Description: Delete the CLI command directory."   
  echo "Usage: kone cli delete-command [options]"
  echo ""
  echo "Options:"
  echo "  -h, --help              Show command line help."
  echo "  -c, --command-name      The name of the command to delete."
  echo ""
  echo "Examples:"
  echo "  kone cli delete-command --help"
  echo "  kone cli delete-command --command-name hello"
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
      exit 0
      ;;
    delete-command)
      ;;
    -c|--command-name)
      shift
      command_name="${1}"
      ;;
    *)
      say_err "$(unknown_command_message "${key}")"
      exit 3
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

say "${green:-}Success${normal:-} Command has been deleted."
exit 0