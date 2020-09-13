#!/usr/bin/env sh

generate_table() {
  local func="$1"
  local line word
  IFS= read -r line

  printf '| '
  local words_read=0
  for word in $line; do
    case "$words_read" in
      0) : ;;
      1) printf "%-18s" "value counts" ;;
      *) printf "%12s" "$word" ;;
    esac
    [ $words_read -gt 0 ] && printf ' |'
    words_read=$((words_read + 1))
  done
  printf '\n'

  local first_column=true
  for x in $(seq 1 7); do
    if $first_column; then
      printf '| :----------------- '
      first_column=false
    else
      printf '| ----------: '
    fi
  done
  printf '|\n'

  local min='' skipped=false
  while IFS= read -r line; do
    first_column=true

    for word in $line; do
      if $first_column; then
        if [ -n "$func" ]; then
          case "$word" in
            */$func)
             printf '| %-18s |' '`'"${word%/$func}"'`'
             ;;

            *)
             skipped=true
             continue
             ;;
          esac
        else
          printf '| %-18s |' '`'"$word"'`'
        fi
        first_column=false
      else
        if [ -n "$min" ]; then
          printf '%12s |' "$min $word"
          min=''
        else
          case "$word" in
            *m) min="$word" ;;
             *) printf '%12s |' "$word" ;;
          esac
        fi
      fi
    done
    $skipped || printf '\n'
    skipped=false
  done
}

set_benchmarks() {
  local input="$1"
  sub() {
    main -i"$input" ${1:+-f}$1 | tr '\n' '\r' | sed 's/\//\\\//g'
  }
  sed "{
    s/<table:all>/`sub`/g;
    s/<table:basic>/`sub basic`/g;
    s/<table:basic-ext>/`sub basic-ext`/g;
    s/<table:posix>/`sub posix`/g;
    s/<table:subarray>/`sub subarray`/g;
    s/<table:final>/`sub final`/g;
    s/<table:g100>/`sub g100`/g;
    s/<table:g100-ext>/`sub g100-ext`/g;
    s/<table:tool>/`sub tool`/g;
    s/<table:ctool>/`sub ctool`/g;
    s/<table:pure-tool>/`sub pure-tool`/g;
    s/<table:pure-ctool>/`sub pure-ctool`/g;
 }" | tr '\r' '\n'
}

main() {
  local input=benchmarks func genmd=false md_template='benchmarks.md.template'
  while [ $# -gt 0 ]; do
    case "$1" in
      --function|-f)
        func="$2"
        shift 2
        ;;

      --function=*)
        func="${1#--function=}"
        shift
        ;;

      -f*)
        func="${1#-f}"
        shift
        ;;

      --input|-i)
        input="$2"
        shift 2
        ;;

      --input=*)
        input="${1#--input=}"
        shift
        ;;

     -i*)
        input="${1#-i}"
        shift
        ;;

     --generate-md|-g)
       genmd=true
       shift
       ;;

     --md-template|-t)
        md_template="$2"
        shift 2
        ;;

      --md-template=*)
        md_template="${1#--md-template=}"
        shift
        ;;

     -t*)
        md_template="${1#-t}"
        shift
        ;;

     '')
       shift
       ;;

     *)
       echo "invalid argument: $1" >&2
       shift
       ;;
    esac
  done
  if [ -f "$input" ]; then
    if $genmd && [ -f "$md_template" ]; then
      cat "$md_template" | set_benchmarks "$input"
    else
      cat "$input" | tr '~' ' ' | generate_table $func
    fi
  fi
}

main "$@"
