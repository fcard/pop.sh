bash_unset_pop() {
  local cut="${2:-1}"
  eval "
    declare -i len=\${#$1[@]}
    for (( i=0; i < cut; i++, len-- )) do
      unset $1[\$len-1]
    done
  "
}

test_eval_bash_pop() {
  eval "set -- ${@:1:$# - 1}"
  echo "$@"
}

test_bash_unset_pop() {
  declare -a array
  array=("$@")
  bash_unset_pop array
  echo "${array[@]}"
}

test_bash_unset_pop_x10000() {
  declare -a array
  array=("$@")
  declare -i len=${#array[@]}
  time for x in {1...10000}; do
    len+=-1
    unset array[$len]
  done
  echo "${array[@]}"
}

