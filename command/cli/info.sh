#!/bin/sh

set -e
. "${ROOT_DIR}/utils/utils.sh"
. "${ROOT_DIR}/utils/sysfetch.sh"

print_sysinfo() {
  # get the latest commit hash for the CLI
  cd "${ROOT_DIR}" && commit=$( git rev-parse --short HEAD );

  echo ""
  echo "${COLOR_DARK_GRAY}KONE CLI:${COLOR_NORMAL}"
  echo "Version: ${CLI_VERSION}"
  echo "Commit: ${commit}"
  echo ""
  exit 3
}

print_sysinfo