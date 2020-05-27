#!/bin/sh

set -e
. "${ROOT_DIR}/utils.sh"

show_help() {
  echo ""
  echo "Description: Builds the project and all of its dependencies into an installable package."
  echo "Usage: kone app build [options]"
  echo ""
  echo "Options:"
  echo "  -h, --help                    Show command line help." 
  echo "  --build-type <BUILD_TYPE>     The version of the app that you want to build."
  echo "  --profile <PROFILE>           Specifies the named profile to use for this command." 
  echo "  --stacktrace                  Show truncated stacktraces from the configured build task." 
  echo ""
  echo "Examples:"
  echo "  kone app build"  
  echo "  kone app build --stacktrace"      
  echo "  kone app build --build-type assembleDebug"
  echo ""
}

profile="default"
build_type="${BUILD_TYPE}"
non_dynamic_params=""

while [ $# -ne 0 ]
do
  key="${1}" 
  case "${key}" in
    -h|--help|help)
      show_help
      exit 3
      ;;
    build)
      ;;
    --build-type)
      shift
      build_type=="${1}"
      ;;     
    --profile)
      shift
      profile=="${1}"
      ;;
    --stacktrace)
      non_dynamic_params+=" --stacktrace"
      ;;
    *)
      say_err "$(unknown_command_message "${key}")"
      exit 3
      ;;
  esac
  shift
done

gradlew_path="$(combine_paths $(get_project_path) "/android/FieldService-Android")"
cd "${gradlew_path}"

./gradlew clean ${build_type} ${non_dynamic_params}
exit 0