Files="a b c d e f g h i j k l m n o p q r s"
Fast=false
VeryFast=false
NoMultiply=false

existing_files() {
  for file in $Files; do
    if [ -f "bench/$file" ]; then
      echo "bench/$file"
    fi
  done
}

procs() {
  for file in $Files; do
    eval "echo \$$file"
  done
}

cleanup() {
  echo "cleaning up..."
  for file in $(existing_files); do
    rm $file
  done
  for proc in $(procs); do
    if kill -0 $proc 2>/dev/null; then
      eval "echo \"ending process \$name$proc\""
      kill $proc
    fi
  done
  pkill -P $$
  exit 1
}

trap 'cleanup' KILL QUIT INT TERM

bench() {
  local shell="$1"
  local func="$2"
  local letter="$3"
  local multiply="${4:-1}"
  local iter=10000
  if [ -n "$multiply" ]; then
    $NoMultiply && multiply=1
    $Fast && multiply=$((multiply * 10))
    $VeryFast && multiply=$((multiply * 10))
    iter=$((iter / multiply))
  fi

  echo "$shell/$func" >bench/$letter
  {
    echo "starting $shell/$func..."
    sh popbench.sh ${multiply:+-x}$multiply -s $shell -f $func -i $iter -n 1,5,10,100,1000,10000 -o bench/$letter &
    trap "{ kill -9 $!; exit 1; }" KILL QUIT INT TERM
    wait
    echo "finished $shell/$func!"
  } &
  eval "$letter=$!"
  eval "name$!=$shell/$func"
  eval "name_$letter=$shell/$func"
}

bench_group() {
  local func="$1"
  $func

  results="${2:-bench/results}"
  if [ -n "$(existing_files)" ]; then
    printf '' >$results
    for file in $(existing_files); do
      local name="$(eval "printf '%-16s' \$name_${file#bench/}")"
      name="$(echo "$name" | sed 's/\//\\\//')"
      while IFS="" read -r line; do
        case "$line" in
          int*) echo "$line" | sed "s/int/$name/" >>$results ;;
        esac
      done <"$file"
    done
    rm $(existing_files)
  fi
}

print_value_count() {
  printf '%-16s' 'value count'
  for value in "$@"; do
    printf '	%13s' "$(printf '%-3s' "$value")"
  done
  printf '\n'
}

first() {
  printf '%s' "$1"
}

main() {
  local all=false any=false
  local benchmarks=''

  while [ $# -gt 0 ]; do
    case "$1" in
      --fast|-f)
        Fast=true
        shift
        ;;
      --very-fast|-v)
        Fast=true
        VeryFast=true
        shift
        ;;
      --no-multiply|-n)
        NoMultiply=true
        shift
        ;;
      all)
        all=true
        shift
        ;;
      final|posix|array|basic|g100|tool|eval)
        any=true
        benchmarks="$benchmarks $1"
        shift
        ;;
      pure-tool)
        any=true
        benchmarks="$benchmarks $(echo "$1" | tr '-' '_')"
        shift
        ;;
    esac
  done

  if $all || ! $any; then
    all=true
    benchmarks=" final posix array basic g100 tool pure_tool"
  fi

  mkdir -p bench
  for benchmark in $benchmarks; do
    bench_group $benchmark bench/$benchmark
  done

  wait

  print_value_count 1 5 10 100 1000 10000 >benchmarks.temp
  cat bench/* >>benchmarks.temp
  rm -r bench

  if [ -f benchmarks ] && ! $all; then
    sed -i '1d' benchmarks.temp
    printf '' >benchmarks.temp2
    local line new_line key
    while IFS= read -r line; do
      key="$(first $line)"
      new_line="$(grep -e "^$key " benchmarks.temp 2>/dev/null)"
      if [ -n "$new_line" ]; then
        printf '%s\n' "$new_line" >>benchmarks.temp2
        sed -i "/^$(echo "$key" | sed 's/\//\\\//g') /d" benchmarks.temp
      else
        printf '%s\n' "$line" >>benchmarks.temp2
      fi
    done <benchmarks
    cat benchmarks.temp2 benchmarks.temp >benchmarks
    rm benchmarks.temp benchmarks.temp2
  else
    cat benchmarks.temp >benchmarks
    rm benchmarks.temp
  fi
}

final() {
  bench dash final a; wait
  bench ash  final b; wait
  bench ksh  final c; wait
  bench bash final d; wait
  bench zsh  final e; wait
}

posix() {
  bench dash posix a; wait
  bench ash  posix b; wait
  bench ksh  posix c; wait
  bench bash posix d; wait
  bench zsh  posix e 10; wait
}

array() {
  bench bash subarray a
  bench zsh  subarray b
  wait
  bench bash bash-unset c
  bench zsh  zsh-unset  d
  wait
}


basic() {
  bench dash basic  a 5
  bench ash  basic  b 5
  bench ksh  basic  c
  wait
  bench bash basic  d 50
  bench zsh  basic  e 25
  wait
  bench ksh  basic-ext f
  bench bash basic-ext g 10
  bench zsh  basic-ext h 10
  wait
}

g100() {
  bench bash g100 a
  bench dash g100 b
  bench ash  g100 c
  wait
  bench ksh  g100 d
  bench zsh  g100 e 10
  wait
  bench bash g100-ext g
  bench ksh  g100-ext h
  wait
}

tool() {
  bench bash tool  a; wait
  bench dash tool  b; wait
  bench ash  tool  c; wait
  bench ksh  tool  d; wait
  bench zsh  tool  e 10; wait

  bench bash ctool f; wait
  bench dash ctool g; wait
  bench ash  ctool h; wait
  bench ksh  ctool i; wait
  bench zsh  ctool j 10; wait
}

pure_tool() {
  bench bash pure-tool  a; wait
  bench dash pure-tool  b; wait
  bench ash  pure-tool  c; wait
  bench ksh  pure-tool  d; wait
  bench zsh  pure-tool  e 10; wait

  bench bash pure-ctool f; wait
  bench dash pure-ctool g; wait
  bench ash  pure-ctool h; wait
  bench ksh  pure-ctool i; wait
  bench zsh  pure-ctool j 10; wait
}

eval() {
  bench zsh  eval-zsh  a 10; wait
  bench bash eval-bash b 10; wait
}


main "$@"
