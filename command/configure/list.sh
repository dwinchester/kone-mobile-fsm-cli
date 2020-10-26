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
echo "Name                          Value"
echo "----                          -----"
echo "profile_name                  ${profile}"
echo "debug                         ${DEBUG}"
echo "asset_relative_path           ${ASSET_RELATIVE_PATH}"
echo "github_repo                   ${GITHUB_REPO}"
echo "launch_file_relative_path     ${LAUNCH_FILE_RELATIVE_PATH}"
echo "apk_path                      ${APK_PATH}"
echo "app_platform                  ${APP_PLATFORM}"
echo "branch_main                   ${BRANCH_MAIN}"
echo "branch_submodule              ${BRANCH_SUBMODULE}"
echo "build_type                    ${BUILD_TYPE}"
echo "device_id                     ${DEVICE_ID}"
echo "package_name                  ${PACKAGE_NAME}"
echo "logging_files_path            ${LOGGING_FILES_PATH}"
echo "install_dir                   ${INSTALL_DIR}"
echo "verbose                       ${VERBOSE}"
echo "version_tag                   ${VERSION_TAG}"
echo ""
exit 0