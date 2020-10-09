#!/bin/sh

# shellcheck disable=SC2034 # These are defined, even if not used, for simplicity's sake
COLOR_BLACK="\033[30m"
COLOR_RED="\033[31m"
COLOR_GREEN="\033[32m"
COLOR_YELLOW="\033[33m"
COLOR_BLUE="\033[34m"
COLOR_MAGENTA="\033[35m"
COLOR_CYAN="\033[36m"
COLOR_LIGHT_GRAY="\033[37m"
COLOR_DARK_GRAY="\033[38m"
COLOR_NORMAL="\033[39m"

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