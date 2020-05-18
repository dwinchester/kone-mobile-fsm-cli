#!/bin/sh

echo ""
echo "Description: Automates mobile app deployments to the KONE Firebase instance."
echo "Usage: kone deploy [options] [[--] <additional arguments>]]"
echo ""
echo "Options:"
echo "  create-release      Creates the required release branches for the project."
echo "  list-tags           List all tags."
echo "  push                Update the project with final changes required for the release."
echo "  tag-release         Creates the tag to mark a release point with the configured version number. Triggers the `Firebase QA deploy` pipeline."
echo ""
echo "Run 'kone [command] -h|--help' for more information on a command."
echo ""
exit 3