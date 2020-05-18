#!/bin/sh

set -e
. "${ROOT_DIR}/utils.sh"

cd "$(get_project_path)"

# commit and push final changes:

git add .
git commit -m "Updated release ${VERSION_TAG}"
git push
exit 0