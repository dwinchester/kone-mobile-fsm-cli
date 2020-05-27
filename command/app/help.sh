#!/bin/sh

echo ""
echo "Description: Provides mobile developers and testers with the capabilities to manage their local projects."
echo "Usage: kone app [options] [[--] <additional arguments>]]"
echo ""
echo "Options:"
echo "  build               Builds the project and all of its dependencies into an installable package."
echo "  bundle              Bundles the react-native dependencies for offline use."
echo "  delete-project      Delete the project from the configure install directory."
echo "  get-project         Clone the project and install project-to-project dependencies."
echo "  help                Show command line help."
echo "  install             Installs a package to a device."
echo "  list-avds           List of virtual device names."
echo "  list-devices        List of connected device names."
echo "  list-packages       Prints all packages on the running device."
echo "  install             Installs a package to a device."
echo "  run                 Run a package on a device."
echo "  start-device        Displays a list of installed emulators and prompts the user to start one."
echo "  uninstall           Removes a package from a device."
echo "  update-check        Checks if there are updates available for the project."
echo "  update-project      Checks if there are updates available for the project and installs them."
echo "  watch               Get diagnostic output for all system services running on a device."
echo ""
echo "Run 'kone [command] -h|--help' for more information on a command."
echo ""
exit 3