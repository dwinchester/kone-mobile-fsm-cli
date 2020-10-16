#!/bin/sh

. "${ROOT_DIR}/utils/utils.sh"
get_theme

echo ""
echo "${COLOR_YELLOW}Create and remove CLI commands.${COLOR_NORMAL}"
echo ""
echo "${COLOR_DARK_GRAY}VERSION:${COLOR_NORMAL} ${BACKGROUND_BLUE}${CLI_VERSION}${BACKGROUND_NORMAL}"
echo ""
echo "${COLOR_DARK_GRAY}USAGE:${COLOR_NORMAL}" 
echo "${COLOR_GREEN}kone${COLOR_NORMAL} ${COLOR_YELLOW}cli${COLOR_NORMAL} ${COLOR_CYAN}[command-options]${COLOR_NORMAL} ${COLOR_MAGENTA}[arguments]${COLOR_NORMAL}"       
echo ""
echo "${COLOR_DARK_GRAY}COMMAND-OPTIONS:${COLOR_NORMAL}    ${COLOR_DARK_GRAY}DESCRIPTION:${COLOR_NORMAL}"
echo "${COLOR_CYAN}create-command${COLOR_NORMAL}      ${COLOR_LIGHT_GRAY}Create a new CLI command.${COLOR_NORMAL}"
echo "${COLOR_CYAN}debug${COLOR_NORMAL}               ${COLOR_LIGHT_GRAY}Enable or disable the debug flag in the configured profile.${COLOR_NORMAL}"
echo "${COLOR_CYAN}delete-command${COLOR_NORMAL}      ${COLOR_LIGHT_GRAY}Delete a CLI command directory.${COLOR_NORMAL}"
echo "${COLOR_CYAN}grant-permission${COLOR_NORMAL}    ${COLOR_LIGHT_GRAY}Recursively makes all permissions 775 on the cli directory.${COLOR_NORMAL}"
echo "${COLOR_CYAN}help${COLOR_NORMAL}                ${COLOR_LIGHT_GRAY}Show command line help.${COLOR_NORMAL}"
echo "${COLOR_CYAN}update${COLOR_NORMAL}              ${COLOR_LIGHT_GRAY}Updates the CLI to the latest version.${COLOR_NORMAL}"
echo "${COLOR_CYAN}version${COLOR_NORMAL}             ${COLOR_LIGHT_GRAY}Prints out the version of the CLI in use.${COLOR_NORMAL}" 
echo ""
echo "Or, simply run:"
echo "$ ${COLOR_GREEN}kone${COLOR_NORMAL} ${COLOR_YELLOW}cli${COLOR_NORMAL} ${COLOR_CYAN}[command-options]${COLOR_NORMAL} ${COLOR_MAGENTA}-h|--help${COLOR_NORMAL} for more information on a command."
echo ""
exit 3