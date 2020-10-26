#!/bin/sh

set -e
. "${ROOT_DIR}/utils/utils.sh"

show_help() {
  echo ""
  echo "${COLOR_YELLOW}Displays your current configuration values.${COLOR_NORMAL}"
  echo ""
  echo "${COLOR_DARK_GRAY}VERSION:${COLOR_NORMAL} ${BACKGROUND_BLUE}${CLI_VERSION}${BACKGROUND_NORMAL}"
  echo ""
  echo "${COLOR_DARK_GRAY}USAGE:${COLOR_NORMAL}" 
  echo "${COLOR_GREEN}kone${COLOR_NORMAL} ${COLOR_YELLOW}configure${COLOR_NORMAL} ${COLOR_CYAN}list${COLOR_NORMAL} ${COLOR_MAGENTA}[arguments]${COLOR_NORMAL}"       
  echo ""
  echo "${COLOR_DARK_GRAY}ARGUMENTS${COLOR_NORMAL}               ${COLOR_DARK_GRAY}DESCRIPTION:${COLOR_NORMAL}"
  echo "${COLOR_MAGENTA}-h, --help${COLOR_NORMAL}              ${COLOR_LIGHT_GRAY}Show command line help.${COLOR_NORMAL}"
  echo "${COLOR_MAGENTA}-p, --profile${COLOR_NORMAL}           ${COLOR_LIGHT_GRAY}Specifies the named profile to use for this command.${COLOR_NORMAL}"
  echo ""
  echo "${COLOR_DARK_GRAY}EXAMPLES:${COLOR_NORMAL}" 
  echo "$ ${COLOR_GREEN}kone${COLOR_NORMAL} ${COLOR_YELLOW}configure${COLOR_NORMAL} ${COLOR_CYAN}list${COLOR_NORMAL}"
  echo "$ ${COLOR_GREEN}kone${COLOR_NORMAL} ${COLOR_YELLOW}configure${COLOR_NORMAL} ${COLOR_CYAN}list${COLOR_NORMAL} ${COLOR_MAGENTA}--profile ios${COLOR_NORMAL}"
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

config_file="${ROOT_DIR}/config/${profile}.settings"

if [ ! -f "${config_file}" ]; then
  say_err "No such profile found: ${profile}"
  exit 0
fi

echo ""
echo "SETTING                       VALUE"
echo "--------                      ------"
echo "PROFILE_NAME                  ${profile}"
echo "DEBUG                         ${DEBUG}"
echo "ASSET_RELATIVE_PATH           ${ASSET_RELATIVE_PATH}"
echo "GITHUB_REPO                   ${GITHUB_REPO}"
echo "LAUNCH_FILE_RELATIVE_PATH     ${LAUNCH_FILE_RELATIVE_PATH}"
echo "APK_PATH                      ${APK_PATH}"
echo "APP_PLATFORM                  ${APP_PLATFORM}"
echo "BRANCH_MAIN                   ${BRANCH_MAIN}"
echo "BRANCH_SUBMODULE              ${BRANCH_SUBMODULE}"
echo "BUILD_TYPE                    ${BUILD_TYPE}"
echo "DEVICE_ID                     ${DEVICE_ID}"
echo "PACKAGE_NAME                  ${PACKAGE_NAME}"
echo "LOGGING_FILES_PATH            ${LOGGING_FILES_PATH}"
echo "INSTALL_DIR                   ${INSTALL_DIR}"
echo "VERBOSE                       ${VERBOSE}"
echo "VERSION_TAG                   ${VERSION_TAG}"
echo ""
exit 0