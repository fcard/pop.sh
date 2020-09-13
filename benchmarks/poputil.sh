set_number() {
  case "$2" in
    ''|*[!0-9]*) echo "error: argument not a number: $2" >&2; return 1 ;;
    *) [ -n "$1" ] && eval "$1=$2" ;;
  esac
  return 0
}

set_number_list() {
  case "$2" in
    ''|*[!0-9,]*) echo "error: argument not a number list: $2" >&2; return 1 ;;
    *) [ -n "$1" ] && eval "$1='$(echo "$2" | sed 's/,/ /g')'" ;;
  esac
  return 0
}

set_name() {
  case "$2" in
    *[!a-zA-Z0-9_]*) echo "error: argument not a name: $2" >&2 ;;
    *) eval "$1=$2" ;;
  esac
}


format_elapsed() {
  local start="$1"
  local finish="$2"
  local multiply="$3"
  local time="$(echo "scale=3; ($finish - $start)" | bc)"
  printf '\nint%s\n' "$(format_time $time $multiply)"
}

format_time() {
  local time="$1"
  local multiply="$2"
  local tilde=''

  if [ -n "$multiply" -a "$multiply" != 1 ]; then
    time=$(echo "$time * $multiply" | bc)
    tilde='~'
  fi
  local mins=$(echo "scale=0; $time / 60" | bc)
  local secs=$(echo "scale=3; $time - (60 * $mins)" | bc)
  case "$secs" in
    .*) secs=0$secs ;;
  esac
  printf '	%3dm%6.3fs%-1s' $mins $secs "$tilde"
}

