#!/bin/sh

set -e
. "${ROOT_DIR}/utils.sh"

cd "${ROOT_DIR}"

say "Checking for updates."
git pull

say "${green:-}Success${normal:-} CLI up-to-date."
exit 0