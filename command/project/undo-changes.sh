#!/bin/sh

set -e
. "${ROOT_DIR}/utils/utils.sh"

undo() {
  git reset --hard # undo all staged changes
  git clean -fd # unstage changes (files and directories)
}

help_arg=2
if [ "${!help_arg}" == "help" ]; then
  say "Usage: kone project undo-changes"  
  exit 3
fi

project_path="$(get_project_path)"
cd "${project_path}"

undo
cd "android/React" && undo

say "${BACKGROUND_GREEN}Success${BACKGROUND_NORMAL} All changes reverted."
exit 0