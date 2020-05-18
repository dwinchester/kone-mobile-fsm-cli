#!/bin/sh

set -e
. "${ROOT_DIR}/utils.sh"

show_help() {
  echo ""
  echo "Description: Displays your current configuration values." 
  echo "Usage: kone configure list [options]"
  echo ""
  echo "Options:"
  echo "  -h, --help              Show command line help."  
  echo "  --profile <PROFILE>     Specifies the named profile to use for this command."   
  echo ""
}

while [ $# -ne 0 ]
do
  key="${1}" 
  case "${key}" in
    -h|--help|help)
      show_help
      exit 3
      ;;
    list)
      ;;
    -p|--profile)
      shift
      profile="${1}"
      ;;     
    *)
      say_err "$(unknown_command_message "${key}")"
      exit 3
      ;;
  esac
  shift
done

# if the path to the named profile does not exist, then we will show the content
# of the default profile from the CLI settings
config_file="$(resolve_profile_path ${profile})"

cat "${config_file}"
exit 0