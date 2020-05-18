#!/bin/sh

set -e
. "${ROOT_DIR}/utils.sh"

if [ $# == 1 ]; then
  exit 3
fi

cmd_dir="${ROOT_DIR}/command"

if [[ $# -gt 1 ]]; then
  dir="${2}"
  cmd_dir="${cmd_dir}/${dir}"

  if [[ ! -d "${cmd_dir}" ]]; then
    exit 0
  fi

  # remove the directory and all its contents
  rm -rf "${cmd_dir}"
fi

say "${green:-}SUCCESS${normal:-}"
exit 0