# remove last parameter from parameter list
# usage: pop $#; eval "$POP_EXPR"
pop() {
  local n=$(($1 - ${2:-1}))
  if [ -n "$ZSH_VERSION" -o -n "$BASH_VERSION" ]; then
    POP_EXPR='set -- "${@:1:'$n'}"'
  elif [ $n -ge 500 ]; then
    POP_EXPR="set -- $(seq -s " " 1 $n | sed 's/[0-9]\+/"${\0}"/g')"
  else
    local index=0
    local arguments=""
    while [ $index -lt $n ]; do
      index=$((index+1))
      arguments="$arguments \"\${$index}\""
    done
    POP_EXPR="set -- $arguments"
  fi
}

pop_next() {
  if [ -n "$BASH_VERSION" -o -n "$ZSH_VERSION" ]; then
    local np="${POP_EXPR##*:}"
    np="${np%\}*}"
    POP_EXPR="${POP_EXPR%:*}:$((np == 0 ? 0 : np - 1))}\""
    return
  fi
  POP_EXPR="${POP_EXPR% \"*}"
}



test_pop() {
  pop $#
  eval "$POP_EXPR"
  echo "$@"
}
