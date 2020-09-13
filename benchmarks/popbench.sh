#!/usr/bin/env sh

. ./popksh.sh
. ./poputil.sh

FunctionFiles="all ext array zsh bash"

main() {
  local benchmark_type='' func='' shell='' iterations=10000 argnum=1000 pattern='\0'
  local output=/dev/stdout verbose=false multiply=''

  set_benchmark() {
    case "$1" in
      posix-dash|posix-bash|gen-dash|gen-bash|subarray-bash)
        benchmark_type=$1
        ;;
      *)
        echo "Invalid benchmark type: $1" >&2
        return 1
        ;;
    esac
  }

  set_argnum() {
    argnum="$(echo "$1" | sed -e 's/,/ /g')"
  }

  set_shell() {
    case "$1" in
      bash|zsh|dash|ksh|ash)
        shell="$1"
        ;;
      *)
        echo "Invalid shell: $1" >&2
        return 1
        ;;
    esac
  }

  set_function() {
    case "$1" in
      ''|[0-9]*|*[!a-zA-Z0-9-]*) echo "invalid function: $1" >&2  ;;
      final) func="test_pop" ;;
      shift) func="test_shift" ;;
      *-*)   func="test_${1%-*}_${1#*-}_pop" ;;
      *)     func="test_$1_pop" ;;
    esac
  }

  while [ $# -gt 0 ]; do
    case "$1" in
      --shell=*)
        set_shell "${1#--shell=}"
        shift
        ;;

      -s)
        set_shell "$2"
        shift 2
        ;;

      --zsh|--bash|--dash|--ksh|--ash)
        shell=${1#--}
        shift
        ;;

      --function=*)
        set_function "${1#--function=}"
        shift
        ;;

      -f)
        set_function "$2"
        shift 2
        ;;

      -f*)
        set_function "${1#-f}"
        shift
        ;;

      --list-functions|-l)
        local file line
        printf 'final'
        for file in $FunctionFiles; do
          while read -r line; do
            case "$line" in
              *test*_pop\(\)*)
                 local name
                 name="${line#*test_}"
                 name="${name%_pop*}"
                 printf ' %s' "$name" | sed 's/_/-/g'
                 ;;
             esac
          done <"popfunctions_$file.sh"
        done
        printf '\n'
        shift
        ;;

      --output=*)
        output="${1#--output=}"
        shift
        ;;

      -o)
        output="$2"
        shift 2
        ;;

      --benchmark=*)
        set_benchmark "${1#--benchmark=}"
        shift
        ;;

      -b)
        set_benchmark "$2"
        shift 2
        ;;

      -b*)
        set_benchmark "${1#-b}"
        shift
        ;;

      --iterations=*)
        set_number iterations "${1#--iterations=}"
        shift
        ;;

      -i)
        set_number iterations "$2"
        shift 2
        ;;

      -i*)
        set_number iterations "${1#-i}"
        shift
        ;;

      --argument-numbers=*)
        set_number_list argnum "${1#--argument-number=}"
        shift
        ;;

      -n)
        set_number_list argnum "$2"
        shift 2
        ;;

      -n*)
        set_number_list argnum "${1#-n}"
        shift
        ;;

      --argument-pattern=*)
        pattern="${#1--argument-pattern=}"
        shift
        ;;

      --argument-pattern|-a)
        pattern="$2"
        shift 2
        ;;

      -a*)
        pattern="${1#-a}"
        shift
        ;;

      --verbose|-v)
        verbose=true
        shift
        ;;

      --multiply-timer=*)
        set_number multiply "${1#--multiply-timer=}"
        shift
        ;;

      --multiply-timer|-x)
        set_number multiply "$2"
        shift 2
        ;;

      -x*)
        set_number multiply "${1#-x}"
        shift
        ;;

      *)
        echo "invalid argument: $1"
        shift
        ;;
    esac
  done

  if [ -n "$benchmark_type" ]; then
    case "$benchmark_type" in
      posix-dash)
        shell=dash
        func=posix_pop
        ;;

      posix-bash)
        shell=bash
        func=posix_pop
        ;;

      gen-dash)
        shell=dash
        func=test_pop
        ;;

      gen-bash)
        shell=bash
        func=test_pop
        ;;

      subarray-bash)
        shell=bash
        func=subarray_pop
        ;;
    esac
  fi

  if [ -n "$shell" -a -n "$func" ]; then
    export LC_ALL=C
    benchmark $shell $func $iterations $pattern "$output" $verbose "$multiply" $argnum
  fi
}


benchexpr() {
  local func="$1"
  local times="$2"
  local args="$3"
  local arg="${4:-\0}"
  local multiply="$5"
  printf '%s' "{
    __i=0
    printf '\nval $args\n'
    start=\$(date +%s.%N)
    while [ \$__i -lt $times ]; do
      $func $(seq -s ' ' 1 $args | sed -e "s/\(.*\)/$arg/");
      __i=\$((__i+1))
    done
    finish=\$(date +%s.%N)
    format_elapsed \$start \$finish $multiply
  }"
}

test_expr() {
  local shell="$1" func="$2" args="$3" files="$4"

  if [ "$func" = "test_shift" ]; then
    return 0
  fi

  local test="$(printf '%s' "$func $(seq -s ' ' 1 "$args") || exit 1" | handle_ksh "$shell" $files -)"
  local test_result="$(printf '%s' "$test" | "$shell")"

  if [ "$test_result" != "$(seq -s ' ' 1 $((args - 1)))" ]; then
    echo "error: test failed! got the following results: $test_result" >&2
    return 1
  else
    return 0
  fi
}

benchmark() {
  local shell="$1" func="$2" iter="$3" pat="$4" output="$5" verbose="$6" multiply="$7"
  local files="poputil.sh pop.sh popfunctions.sh"

  local val='' real='' user='' sys='' int=''
  shift 7
  for args in "$@"; do
    test_expr "$shell" "$func" "$args" "$files" || return 1
    code=$(benchexpr "$func" "$iter" "$args" "$pat" "$multiply" | handle_ksh "$shell" $files -)
    while IFS="" read -r line; do
      case "$line" in
        val*)  val="$val	$(printf '% 4d%-6s' "${line#val}" '')" ;;
        real*) real="$real$(format_time ${line#real} $multiply)" ;;
        user*) user="$user$(format_time ${line#user} $multiply)" ;;
        sys*)  sys="$sys$(format_time ${line#sys} $multiply)"    ;;
        int*)  int="$int${line#int}" ;;
      esac
      if $verbose; then
        echo "$shell/$func: $line"
      fi
    done <<WHILE
           $( { printf '%s' "$code" | time -p $shell; } 2>&1 )
WHILE
  done
  echo "val  $val"  >>"$output"
  echo "real $real" >>"$output"
  echo "user $user" >>"$output"
  echo "sys  $sys"  >>"$output"
  echo "int  $int"  >>"$output"
}

main "$@"
