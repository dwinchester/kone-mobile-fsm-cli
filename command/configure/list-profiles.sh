#!/bin/sh

set -e
. "${ROOT_DIR}/utils.sh"

dir="${ROOT_DIR}/config"

# show only files with the .settings file extension
cd "${dir}" && ls -1 *.settings
exit 0