#!/bin/sh

set -e
. "${ROOT_DIR}/utils.sh"

# remove the project and all its contents
rm -rf "$(get_project_path)"

say "${green:-}Success${normal:-} Project has been deleted."
exit 0