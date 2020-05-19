#!/bin/sh

# if the emulator command exists on this device, display a list of emulators
# and prompt the user to start one

set -e
. "${ROOT_DIR}/utils.sh"

help_arg=2
if [ "${!help_arg}" == "help" ]; then
  say "Usage: kone app start-device"  
  exit 3
fi

# go to the emulator directory
cd "${HOME}/${ANDROID_HOME}/emulator"

# check if the emulator command exists first
if ! type emulator > /dev/null; then
  say_err "Command not found: emulator"
  exit 1
fi

# gather emulators that exist on this computer
avds=( $(emulator -list-avds 2>&1 ) )

# display list of emulators
echo "Available emulators"
N=1
for avd in ${avds[@]}
do
  echo "$N) $avd"
  let N=$N+1
done

# request an emulator to start
read -p "
Choose an emulator: " num

# if the input is valid, launch our emulator on a separate PID and exit
if [ $num -lt $N ] && [ $num -gt 0 ]; then
  avd=${avds[$num-1]}
  emulator "@$avd" > /dev/null 2>&1 &
  exit 0
else
  say_err "Invalid entry : ${num}"
  exit 1
fi
exit 0