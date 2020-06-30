#!/bin/sh

set -e
. "${ROOT_DIR}/utils.sh"

cd "${ROOT_DIR}"

say "Checking for updates."

# get all changes from the remote repository
git pull >/dev/null

say "${green:-}Success${normal:-} CLI up to date."
exit 0