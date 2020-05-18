#!/bin/sh

set -e
. "${ROOT_DIR}/utils.sh"

cd "${ROOT_DIR}"

upstream=${1:-'@{u}'}
local=$(git rev-parse @)
remote=$(git rev-parse "${upstream}")
base=$(git merge-base @ "${upstream}")

if [ "${local}" = "${remote}" ]; then
  say "Up-to-date"
elif [ "${local}" = "${base}" ]; then
  say "Need to pull"
elif [ "${remote}" = "${base}" ]; then
  say "Need to push"
else
  say "Diverged"
fi

# git pull
exit 0