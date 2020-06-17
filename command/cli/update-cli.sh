#!/bin/sh

set -e
. "${ROOT_DIR}/utils.sh"

cd "${ROOT_DIR}"

say "Checking for updates."

changed=0
message=""

git remote update && git status -uno | grep -q 'Your branch is behind.' && changed=1

if [ {${changed}} = 1 ]; then
  git pull
  message="CLI update completed.";
else
  message="CLI up-to-date. No changes found."
fi

say "${green:-}Success${normal:-} ${message}"
exit 0