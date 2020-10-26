#!/bin/sh

. "${ROOT_DIR}/utils/utils.sh"
get_theme

echo ""
echo "${COLOR_YELLOW}Configure your CLI profile.${COLOR_NORMAL}"
echo ""
echo "${COLOR_DARK_GRAY}VERSION:${COLOR_NORMAL} ${BACKGROUND_BLUE}${CLI_VERSION}${BACKGROUND_NORMAL}"
echo ""
echo "${COLOR_DARK_GRAY}USAGE:${COLOR_NORMAL}" 
echo "${COLOR_GREEN}kone${COLOR_NORMAL} ${COLOR_YELLOW}configure${COLOR_NORMAL} ${COLOR_CYAN}[command-options]${COLOR_NORMAL} ${COLOR_MAGENTA}[arguments]${COLOR_NORMAL}"   
echo ""
echo "${COLOR_DARK_GRAY}COMMAND-OPTIONS:${COLOR_NORMAL}    ${COLOR_DARK_GRAY}DESCRIPTION:${COLOR_NORMAL}"
echo "${COLOR_CYAN}get${COLOR_NORMAL}                 ${COLOR_LIGHT_GRAY}Get a configuration value from the config file.${COLOR_NORMAL}"     
echo "${COLOR_CYAN}help${COLOR_NORMAL}                ${COLOR_LIGHT_GRAY}Show command line help.${COLOR_NORMAL}" 
echo "${COLOR_CYAN}list-profiles${COLOR_NORMAL}       ${COLOR_LIGHT_GRAY}List the profiles available to the CLI.${COLOR_NORMAL}"
echo "${COLOR_CYAN}list${COLOR_NORMAL}                ${COLOR_LIGHT_GRAY}Displays your current configuration values.${COLOR_NORMAL}" 
echo "${COLOR_CYAN}new${COLOR_NORMAL}                 ${COLOR_LIGHT_GRAY}Copies the default profile template and creates a new profile.${COLOR_NORMAL}"  
echo "${COLOR_CYAN}set-default${COLOR_NORMAL}         ${COLOR_LIGHT_GRAY}Sets a profile as the default config file.${COLOR_NORMAL}"   
echo "${COLOR_CYAN}set${COLOR_NORMAL}                 ${COLOR_LIGHT_GRAY}Set a configuration value from the config file.${COLOR_NORMAL}"   
echo ""     
echo "Or, simply run:"
echo "$ ${COLOR_GREEN}kone${COLOR_NORMAL} ${COLOR_YELLOW}configure${COLOR_NORMAL} ${COLOR_CYAN}[command-options]${COLOR_NORMAL} ${COLOR_MAGENTA}-h|--help${COLOR_NORMAL} for more information on a command."
echo ""
exit 3