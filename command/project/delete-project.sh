#!/bin/sh

set -e
. "${ROOT_DIR}/utils/utils.sh"

# remove the project and all its contents
rm -rf "$(get_project_path)"

say "${BACKGROUND_GREEN}Success${BACKGROUND_NORMAL} Project has been deleted."
exit 0