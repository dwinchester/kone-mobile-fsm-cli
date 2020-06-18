#!/bin/sh

echo ""
echo "Usage: kone project [options] [[--] <additional arguments>]]"
echo ""
echo "Options:"
echo "  build               Builds the project and all of its dependencies into an installable package."
echo "  bundle              Bundles the react-native dependencies for offline use."
echo "  clean               Delete all generated files, removes build folders."
echo "  delete-project      Delete the project from the configure install directory."
echo "  diff-head           Show changes between local branches and HEAD."
echo "  get-project         Clone the project and install project-to-project dependencies."
echo "  help                Show command line help."
echo "  list-branches       If no non-option arguments are provided, existing branches are listed."
echo "  list-tags           List  all tags."
echo "  restore             Delete all the existing artifacts and metadata Gradle has previously downloaded."
echo "  switch-branches     Switch branches or restore working tree files. Updates files in the working tree to match the version in the index or the specified tree."
echo "  undo-changes        Unstage all changes (files and directories)."
echo "  update-check        Checks if there are updates available for the project."
echo "  update-project      Checks if there are updates available for the project and installs them."
echo ""
echo "Run 'kone [command] -h|--help' for more information on a command."
echo ""
exit 3