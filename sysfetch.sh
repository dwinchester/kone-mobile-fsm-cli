#!/bin/sh

kernel_name=""
kernel_version=""
kernel_machine=""
title_fqdn="off" # options are 'on', 'off'

cache_uname() {
  # cache the output of uname so we don't have to spawn it multiple times
  IFS=" " read -ra uname <<< "$(uname -srm)"

  kernel_name="${uname[0]}"
  kernel_version="${uname[1]}"
  kernel_machine="${uname[2]}"

  if [[ "$kernel_name" == "Darwin" ]]; then
    IFS=$'\n' read -d "" -ra sw_vers <<< "$(awk -F'<|>' '/key|string/ {print $3}' \
            "/System/Library/CoreServices/SystemVersion.plist")"
    for ((i=0;i<${#sw_vers[@]};i+=2)) {
      case ${sw_vers[i]} in
        ProductName)          darwin_name=${sw_vers[i+1]} ;;
        ProductVersion)       osx_version=${sw_vers[i+1]} ;;
        ProductBuildVersion)  osx_build=${sw_vers[i+1]}   ;;
      esac
    }
  fi
  echo "${kernel_name}"
  return 0
}

get_os() {
  # $kernel_name is set in a function called cache_uname and is
  # just the output of "uname -s"
  case "${kernel_name}" in
    Darwin)                 os=$darwin_name ;;
    SunOS)                  os=Solaris ;;
    Haiku)                  os=Haiku ;;
    MINIX)                  os=MINIX ;;
    AIX)                    os=AIX ;;
    IRIX*)                  os=IRIX ;;
    FreeMiNT)               os=FreeMiNT ;;
    Linux|GNU*)             os=Linux ;;
    *BSD|DragonFly|Bitrig)  os=BSD ;;
    CYGWIN*|MSYS*|MINGW*)   os=Windows ;;
    *)
      printf '%s\n' "Unknown OS detected: '${kernel_name}', aborting..." >&2
      printf '%s\n' "Open an issue on GitHub to add support for your OS." >&2
      exit 1
      ;;
  esac
}

get_title() {
  # hide/show the fully qualified domain name
  user=${USER:-$(id -un || printf %s "${HOME/*\/}")}

  case "${title_fqdn}" in
      on) 
        hostname=$(hostname -f) 
        ;;
      *)  
        hostname=${HOSTNAME:-$(hostname)} ;;
  esac

  title="${user}${hostname}"
  echo "${title}"
  return 0
}

get_kernel() {
  # since these OS are integrated systems, it's better to skip this function altogether
  [[ "${os}" =~ (AIX|IRIX) ]] && return

  # Haiku uses 'uname -v' and not - 'uname -r'.
  [[ "${os}" == Haiku ]] && {
    kernel=$( uname -v )
    return
  }

  # in Windows 'uname' may return the info of GNUenv thus use wmic for OS kernel
  [[ "${os}" == Windows ]] && {
    kernel=$( wmic os get Version )
    kernel="${kernel/Version}"
    return
  }

  case "${kernel_shorthand}" in
    on)  
      kernel="${kernel_version}" 
      ;;
    off) 
      kernel="${kernel_name $kernel_version}" 
      ;;
  esac

  # hide kernel info if it's identical to the distro info
  [[ "${os}" =~ (BSD|MINIX) && "${distro}" == *"${kernel_name}"* ]] &&
    case "${distro_shorthand}" in
      on|tiny) 
        kernel="${kernel_version}" 
        ;;
      *)       
        unset kernel 
        ;;
    esac

  echo "${kernel}"
  return 0
}

print_sysinfo() {
  echo "Runtime Environment:"
  echo "  Hostname: $( get_title )"
  echo "  Kernel: $( cache_uname )"
}