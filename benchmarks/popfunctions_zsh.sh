zsh_unset_pop() {
  local cut="${2:-1}"
  eval "
    typeset -i len=\${#$1}
    for (( i=0; i < cut; i++, len-- )) do
      $1[\$len]=()
    done
  "
}

test_eval_zsh_pop() {
  eval "set -- ${@:1:$# - 1}"
  echo "$@"
}

test_zsh_unset_pop() {
  typeset -a array=("$@")
  zsh_unset_pop array
  echo "${array[@]}"
}

test_zsh_unset_pop_x10000() {
  typeset -a array=("$@")
  typeset -i len=${#array}
  time for x in {1...10000}; do
    len+=-1
    array[len-1]=()
  done
  echo "${array[@]}"
}

