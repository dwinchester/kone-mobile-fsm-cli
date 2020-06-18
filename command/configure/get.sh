#!/bin/sh

set -e
. "${ROOT_DIR}/utils.sh"

show_help() {
  echo ""
  echo "Usage: kone configure get [options]"
  echo ""
  echo "Options:"
  echo "  -h, --help                Show command line help."  
  echo "  --profile <PROFILE>       Specifies the named profile to use for this command."   
  echo "  --variable <VARNAME>      The name of the config value to retrieve."
  echo ""
  echo "Examples:"
  echo "  kone configure get --help"
  echo "  kone configure get --variable VERSION_TAG"
  echo "  kone configure get --variable PACKAGE_NAME --profile ios"
  echo "" 
}

profile="default"

while [ $# -ne 0 ]
do
  key="${1}" 
  case "${key}" in
    -h|--help|help)
      show_help
      exit 3
      ;;
    get)
      ;;
    --profile)
      shift
      profile="${1}"
      ;;
    --variable)
      shift
      varname="$(to_upper ${1})" # all profile values are uppercase
      ;; 
    *)
      say_err "$(unknown_command_message "${key}")"
      exit 3
      ;;
  esac
  shift
done

config_file="${ROOT_DIR}/config/${profile}.settings"

if [ ! -f "${config_file}" ]; then
  say_warning "Profile '${profile}' not found."
  say "Using default profile: ${blue:-}\`${DEFAULT_PROFILE}\`${normal:-}"

  config_file="${ROOT_DIR}/${DEFAULT_PROFILE}"
fi

if [ -z "${varname}" ]; then
  say_err "Variable value cannot be blank.\nPlease see the project wiki for supported options: https://github.com/konecorp/kone-mobile-fsm-android/wiki/CLI:-configure-get-command."
  exit 1
fi

source "${config_file}"

say "${!varname}"
exit 0