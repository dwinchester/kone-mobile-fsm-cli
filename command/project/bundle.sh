#!/bin/sh

set -e
. "${ROOT_DIR}/utils/utils.sh"

show_help() {
  echo ""
  echo "Usage: kone project bundle [options]"
  echo ""
  echo "Options:"
  echo "  -h, --help                Show command line help." 
  echo "  --reinstall               Removes the existing node modules folder and reinstalls all required packages."
  echo "  --update-apply            Switch branches (or restores working tree files) to the configured branch."
  echo ""
  echo "Examples:"
  echo "  kone project bundle"  
  echo "  kone project bundle --reinstall"
  echo ""
}

update_apply=false

while [ $# -ne 0 ]
do
  key="${1}" 
  case "${key}" in
    -h|--help|help)
      show_help
      exit 3
      ;;
    bundle)
      ;;    
    --reinstall)
      reinstall=true
      ;;
    --update-apply)
      update_apply=true
      ;;
    *)
      say_err "$(unknown_command_message "${key}")"
      exit 3
      ;;
  esac
  shift
done

react_path="$(combine_paths $(get_project_path) "/android/React")"
cd "${react_path}"

# fetch missing commits and update the working tree of the submodule
if [ "${update_apply}" = true ]; then
  say "Updating the registered submodule."

  git checkout "${BRANCH_SUBMODULE}"
  git pull
fi

if [ "${reinstall}" = true ] && [ -d "node_modules" ]; then
  say "Removing directory: ${yellow:-}node_modules${normal:-}."
  # remove existing node modules and reinstall packages
  rm -rf "node_modules"

  say "Reinstalling dependencies."
  npm i
fi

say "Generating bundle for offline use."

react-native bundle \
    --platform android \
    --dev false \
    --entry-file kone.android.js \
    --bundle-output ../FieldService-Android/FieldService-App/src/main/assets/kone.android.bundle \
    --assets-dest ../FieldService-Android/FieldService-App/src/main/res/

say "${BACKGROUND_GREEN}Success${BACKGROUND_NORMAL} Bundle update completed."
exit 0