
subarray_pop() {
  POP_EXPR="set -- \"\${@:1:$1 - ${2:-1}}\""
}

test_subarray_pop() {
  set -- "${@:1:$# - 1}"
  echo "$@"
}

subarray_pop_next() {
  local np="${POP_EXPR##*:}"
  np="${np%\}*}"
  POP_EXPR="${POP_EXPR%:*}:$((np == 0 ? 0 : np - 1))}\""
}