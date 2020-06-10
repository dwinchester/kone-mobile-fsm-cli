#!/bin/sh

set -e
. "${ROOT_DIR}/utils.sh"

show_help() {
  echo ""
  echo "Description: Bundles the react-native dependencies for offline use."
  echo "Usage: kone app bundle [options]"
  echo ""
  echo "Options:"
  echo "  -h, --help                Show command line help." 
  echo "  --reinstall               Removes the existing node modules folder and reinstalls all required packages."
  echo "  --profile <PROFILE>       Specifies the named profile to use for this command." 
  echo "  --update-apply            Switch branches (or restores working tree files) to the configured branch."
  echo ""
  echo "Examples:"
  echo "  kone app bundle"  
  echo "  kone app bundle --reinstall"
  echo ""
}

# TODO: Get named profile

profile="default"
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
    --profile)
      shift
      profile=="${1}"
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

if [ "${update_apply}" = true ]; then
  # fetches from and integrate all changes from the remote repository
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

say "Bundling for offline use."

react-native bundle \
    --platform android \
    --dev false \
    --entry-file kone.android.js \
    --bundle-output ../FieldService-Android/FieldService-App/src/main/assets/kone.android.bundle \
    --assets-dest ../FieldService-Android/FieldService-App/src/main/res/

say "${green:-}Success${normal:-} Project update completed."
exit 0