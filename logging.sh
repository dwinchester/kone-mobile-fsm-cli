  #!/bin/sh

  PKG_PID_LIST_CACHE=$(eval $(pm list packages | cut -d ':' -f 2 | sed 's/^\(.*\)$/echo \"\$\(echo \1\) \$\(pidof \1\)\";/'))
  PROC_PID_LIST_CACHE=$(ps -A -o NAME -o PID)
  PID_LIST_CACHE=$(echo "$PKG_PID_LIST_CACHE\n$PROC_PID_LIST_CACHE")
  MAX_LEN=$(echo "$PID_LIST_CACHE" | cut -d ' ' -f1 | awk '{ if ( length > L ) { L=length} }END{ print L}')
  
  function pid2pkg() {
    pkgName=$(echo "$PID_LIST_CACHE" | grep -w $1 | cut -d ' ' -f1 | head -1);
    if [ "$pkgName" != "" ] ; then
        printf "%-${MAX_LEN}s" "$pkgName";
    else
        printf "%-${MAX_LEN}s" "<UNKNOWN (NOT RUNNING)>";
    fi
  }

  eval "$(\
  logcat -d | \
  sed -r -e 's/([^ ]+) +([^ ]+) +([^ ]+) +([^ ]+) +(.*)/\2\ $\(pid2pkg \3\) \5/g' | \
  sed -r -e 's/(.+)/echo -e \"\1\"/g' \
  )" | \
  awk '
  function color(c,s) {
  printf("\033[%dm%s\033[0m\n",90+c,s)
  }
  / E / {color(1,$0);next}
  / D / {color(2,$0);next}
  / W / {color(3,$0);next}
  / I / {color(4,$0);next}
  {print}
  '