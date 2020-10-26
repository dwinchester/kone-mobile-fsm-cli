#!/bin/sh

set -e
. "${ROOT_DIR}/utils/utils.sh"

cd "${ROOT_DIR}"

say "Checking for updates."

# get all changes from the remote repository
git pull >/dev/null

say "${BACKGROUND_GREEN}Success${BACKGROUND_NORMAL} ${COLOR_GREEN}CLI up-to-date.${COLOR_NORMAL}"
exit 0