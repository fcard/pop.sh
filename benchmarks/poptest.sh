#!/usr/bin/env sh

. ./popksh.sh

test_one() {
  local shell="$1"
  local func="$2"
  local argcount="$3"
  local pattern="$4"

  local files="pop.sh popfunctions.sh"

  make_args() {
    seq -s ' ' 1 $1 | sed 's/\([0-9]\+\)/'"$2/g"
  }

  local args="$(make_args $argcount "\"$pattern\"")"
  local expected="$(make_args $((argcount - 1)) "$pattern")"

  results="$(printf '%s\n' "$func $args" | handle_ksh "$shell" $files - | $shell)"

  local ok
  printf '%5s/%5s = ' "\"$pattern\"" $argcount
  if [ "$results" = "$expected" ]; then
    ok=Ok
  else
    ok='Wrong!'
  fi
  printf '%-8s	' "$ok"
}

test_pair() {
  local shell="$1"
  local func
  local results

  case "$2" in
    ''|[0-9]*|*[!a-zA-Z0-9-]*) echo "invalid function: $2" >&2  ;;
    final) func="test_pop" ;;
    *-*)   func="test_${2%-*}_${2#*-}_pop" ;;
    *)     func="test_$2_pop" ;;
  esac


  printf 'testing %s/%s... \n' $shell $2
  for arg in 1 5 10 100 1000 10000; do
    test_one "$shell" "$func" "$arg" '\0'
    test_one "$shell" "$func" "$arg" 'x\0'
    test_one "$shell" "$func" "$arg" '(\0);'
    printf '\n'
  done
}

test_all_shells() {
  local func="$1"
  test_pair dash $func
  test_pair ash  $func
  test_pair ksh  $func
  test_pair bash $func
  test_pair zsh  $func
}

test_function() {
  local func="$1"
  shift
  if [ "$1" = all ]; then
    test_all_shells $func
  else
    for shell in "$@"; do
      test_pair "$shell" $func
    done
  fi
}

main() {
  if [ $# = 0 ] || [ $1 = 'all' ]; then
    test_function final all
    test_function posix all
    test_function basic all
    test_function basic-ext bash zsh ksh
    test_function subarray zsh bash
    test_function bash-unset bash
    test_function zsh-unset zsh
    test_function g100 all
    test_function g100-ext bash zsh ksh
    test_function tool all
    test_function ctool all
    test_function pure-tool all
    test_function pure-ctool all
  else
    test_function "$@"
  fi
}

main "$@"
