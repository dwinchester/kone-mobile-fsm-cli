#!/bin/sh

set -e
. "${ROOT_DIR}/utils/utils.sh"

config_dir="${ROOT_DIR}/config"

is_default() {
  file_name=${1}

  # determines whether the specified file name matches the currently
  # configured default for the cli
  if [[ "${DEFAULT_PROFILE}" == *"${file_name}"* ]]; then
    echo "DEFAULT"
  fi
}

# show only files with the .settings file extension
cd "${config_dir}"

echo ""
echo "Location"
echo "--------"

N=1
for file in *.settings; do
  echo "~/.kone/config/${file} ${BACKGROUND_YELLOW}$( is_default ${file} )${BACKGROUND_NORMAL}"
  let N=$N+1
done

echo "" # spacing

exit 0