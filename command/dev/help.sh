echo ""
echo "Description: Internal commands used by the mobile development team. These commands are not intended for normal usage."
echo "Usage: kone dev switch-branches [options]"
echo ""
echo "Options:"
echo "  diff-head             Show changes between local branches and HEAD."
echo "  list-branches         If no non-option arguments are provided, existing branches are listed."
echo "  switch-branches       Updates files in the working tree to match the version in the index or the specified tree."
echo "  undo-changes          Resets the current branch HEAD to <COMMIT> and updates the working tree."
echo ""
echo ""
echo "Examples:"
echo "  kone dev diff-head"
echo "  kone dev list-branches --all"
echo "  kone dev switch-branches --main feature/http-logging-xplatform --force"
echo "  kone dev undo-changes"
echo ""
echo "Run 'kone [command] -h|--help' for more information on a command."
echo ""
exit 3