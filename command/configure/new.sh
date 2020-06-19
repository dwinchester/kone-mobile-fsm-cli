#!/bin/sh

set -e
. "${ROOT_DIR}/utils.sh"

show_help() {
  echo ""
  echo "Usage: kone configure new [options] [[--] <additional arguments>]]"
  echo ""
  echo "Options:"
  echo "  -h, --help                        Show command line help."    
  echo "  -p, --profile <PROFILE_NAME>      Specifies the named profile to create."   
  echo "  --set-default                     Sets the newly created profile as the default for the CLI." 
  echo ""
  echo "Examples:"
  echo "  kone configure new --help"
  echo "  kone configure new --profile android-sdk-9"
  echo "  kone configure new --profile ios --set-profile"
  echo "" 
}

set_config() {
  eval $invocation

  sed -i '' "s/\($(to_upper $1) *= *\).*/\1$2/" "${3}"

  return 0
}

copy_profile() {
  eval $invocation

  local source="${1}"
  local target="${2}"

  if [ -f "${target}" ]; then
    say_err "Cannot create profile '${profile}' as it already already exists. Exiting with code 1."
    exit 1
  fi

  say "Copying ${source} to ${target}"
  
  # to see files as they are copied the -v option can be used
  cp "${source}" "${target}" 
  return 0   
}

profile="default"
set_default=false

while [ $# -ne 0 ]
do
  key="${1}" 
  case "${key}" in
    -h|--help|help)
      show_help
      exit 0
      ;;
    new)
      ;;
    -p|--profile)
      shift
      profile="${1}"
      ;;
    --set-default)
      set_default=true
      ;;
    *)
      say_err "$(unknown_command_message "${key}")"
      exit 3
      ;;
  esac
  shift
done

if [ "${profile}" = "default" ]; then
  say_err "Cannot create new profile. The 'profile' option is required. Exiting with code 1."; 
  exit 1;
fi

copy_profile "${ROOT_DIR}/${DEFAULT_PROFILE}" "${ROOT_DIR}/config/${profile}.settings"

if [ "${set_default}" = true ]; then
  set_config "default_profile" "config\/${profile}.settings" "${ROOT_DIR}/cli.settings"
fi

say "${green:-}Success${normal:-} New profile created."
exit 0