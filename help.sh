#!/bin/sh

ROOT_DIR=$(cd $(dirname ${0}) && pwd)
CLI_ENTRYPOINT=$(basename "${1}")

. "${ROOT_DIR}/utils.sh"

# locate the correct level to display the help file for, either a directory
# with no further arguments, or a command file
arg_start=2
cmd_name="${!arg_start}"
cmd_dir="${ROOT_DIR}/command/${cmd_name}"

while [[ -d "${cmd_dir}" && $arg_start -le $# ]]; do
  help_file="${cmd_dir}/help.sh"
  arg_start=$((${arg_start}+1))
done

# if a directory has a help file, then show it
if [[ -d "${cmd_dir}" ]]; then
  if [[ -f "${help_file}" ]]; then
    "${help_file}"
  else
    # no help file was found, so instead show the cli help
    "${ROOT_DIR}/command/help.sh"
  fi
  exit 0
fi