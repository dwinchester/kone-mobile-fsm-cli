#!/bin/sh

chmod -R 775 "${HOME}/.kone/" # update execute permissions

say "${BACKGROUND_GREEN}Success${BACKGROUND_NORMAL} ${COLOR_GREEN}Recursively set permissions on all CLI files to 775.${COLOR_NORMAL}"