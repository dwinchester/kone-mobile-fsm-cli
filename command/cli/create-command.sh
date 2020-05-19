#!/bin/sh

set -e
. "${ROOT_DIR}/utils.sh"

if [ $# == 1 ]; then
  exit 3
fi

cmd_dir="${ROOT_DIR}/command"

# create new command directory
if [[ $# -gt 1 ]]; then
  dir="${2}"
  cmd_dir="${cmd_dir}/${dir}"

  if [[ ! -d "${cmd_dir}" ]]; then
    mkdir "${cmd_dir}"
    say "TODO: Fill out the help information for this command" > "${cmd_dir}/help.sh" # create help file
  fi

  # create subcommmand file and args
  cmd_name="${3}"
  if [[ -f "${cmd_dir}/${cmd_name}.sh" ]]; then
      say_err "That command already exists. Exiting with code 1."
      exit 1
  fi
  say "TODO: The arguments you wish to provide to this command" > "${cmd_dir}/${cmd_name}.sh"
fi

chmod -R 775 "${HOME}/.kone/" # update execute permissions

say "${green:-}Success${normal:-} New command created."
exit 0