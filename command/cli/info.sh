#!/bin/sh

set -e
. "${ROOT_DIR}/sysfetch.sh"

print_sysinfo() {
  # get the latest commit hash for the CLI
  cd "${ROOT_DIR}" && commit=$( git rev-parse --short HEAD );

  echo ""
  echo "KONE Mobile FSM CLI:"
  echo "  Version: ${CLI_VERSION}"
  echo "  Commit: ${commit}"
  echo ""
  echo "CLI settings:"
  echo "  Project Path: $( get_project_path )"
  echo "  Primary branch: ${BRANCH_MAIN}"
  echo "  Submodule branch: ${BRANCH_SUBMODULE}"
  echo "  Version: ${VERSION_TAG}"
  echo "  Device ID: ${DEVICE_ID}"
  echo "  Logging Files Path: ${LOGGING_FILES_PATH}"
  echo ""
  exit 3
}

print_sysinfo