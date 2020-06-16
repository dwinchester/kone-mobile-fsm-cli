#!/bin/sh

echo ""
echo "Description: Automates mobile app deployments to the KONE Firebase instance."
echo "Usage: kone deploy [options] [[--] <additional arguments>]]"
echo ""
echo "Options:"
echo "  create-release      Creates the required release branches for the project."
echo "  help                Show command line help."
echo "  tag-release         Creates the tag to mark a release point with the configured version number."
echo ""
echo "Examples:"
echo "  kone dev create-release"
echo "  kone dev create-release --version 1.2.3"
echo "  kone dev tag-release"
echo ""
echo "Run 'kone [command] -h|--help' for more information on a command."
echo ""
exit 3