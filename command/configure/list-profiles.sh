#!/bin/sh

set -e
. "${ROOT_DIR}/utils/utils.sh"

dir="${ROOT_DIR}/config"

echo "List of profiles"

# show only files with the .settings file extension
cd "${dir}" && ls -1 *.settings
exit 0