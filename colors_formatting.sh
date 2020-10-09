#!/bin/sh

# shellcheck disable=SC2034 # These are defined, even if not used, for simplicity's sake
TEXT_NORMAL="\033[0m"
TEXT_BOLD="\033[1m"
TEXT_BOLD_RESET="\033[21m"
TEXT_UNDERLINE="\033[4m"
TEXT_UNDERLINE_RESET="\033[24m"
TEXT_BLINK="\033[5m"
TEXT_BLINK_RESET="\033[25m"

COLOR_NORMAL="\033[39m"
COLOR_BLACK="\033[30m"
COLOR_RED="\033[31m"
COLOR_GREEN="\033[32m"
COLOR_YELLOW="\033[33m"
COLOR_BLUE="\033[34m"
COLOR_MAGENTA="\033[35m"
COLOR_CYAN="\033[36m"
COLOR_LIGHT_GRAY="\033[37m"
COLOR_DARK_GRAY="\033[90m"
COLOR_LIGHT_RED="\033[91m"
COLOR_LIGHT_GREEN="\033[92m"
COLOR_LIGHT_YELLOW="\033[93m"
COLOR_LIGHT_BLUE="\033[94m"
COLOR_LIGHT_MAGENTA="\033[95m"
COLOR_LIGHT_CYAN="\033[96m"
COLOR_WHITE="\033[97m"

BACKGROUND_NORMAL="\033[49m"
BACKGROUND_BLACK="\033[40m"
BACKGROUND_RED="\033[41m"
BACKGROUND_GREEN="\033[42m"
BACKGROUND_YELLOW="\033[43m"
BACKGROUND_BLUE="\033[44m"
BACKGROUND_MAGENTA="\033[45m"
BACKGROUND_CYAN="\033[46m"
BACKGROUND_LIGHT_GRAY="\033[47m"
BACKGROUND_DARK_GRAY="\033[100m"
BACKGROUND_LIGHT_RED="\033[101m"
BACKGROUND_LIGHT_GREEN="\033[102m"
BACKGROUND_LIGHT_YELLOW="\033[103m"
BACKGROUND_LIGHT_BLUE="\033[104m"
BACKGROUND_LIGHT_MAGENTA="\033[105m"
BACKGROUND_LIGHT_CYAN="\033[106m"
BACKGROUND_WHITE="\033[107m"

# see: https://misc.flogisoft.com/bash/tip_colors_and_formatting

print_colors() {
  for fgbg in 38 48 ; do # Foreground / Background
    for color in {0..255} ; do # Colors
      # Display the color
      printf "\e[${fgbg};5;%sm  %3s  \e[0m" $color $color
      # Display 6 colors per lines
      if [ $((($color + 1) % 6)) == 4 ] ; then
        echo # New line
      fi
    done
    echo # New line
  done
  return 0
}