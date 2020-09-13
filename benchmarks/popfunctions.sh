. ./popfunctions_all.sh

if [ -n "$BASH_VERSION" -o -n "$ZSH_VERSION" ]; then
  . ./popfunctions_array.sh
fi

if [ -n "$BASH_VERSION" -o -n "$ZSH_VERSION" -o -n "$KSH_VERSION" ]; then
  . ./popfunctions_ext.sh
fi

if [ -n "$BASH_VERSION" ]; then
  . ./popfunctions_bash.sh
elif [ -n "$ZSH_VERSION" ]; then
  . ./popfunctions_zsh.sh
fi

test_shift() {
  shift
}

test_inline_basic_pop() {
  local index=0 index2 index3 index4
  local arguments=""
  while [ $index -lt $(($#-1)) ]; do
    index=$((index+1))
    arguments="$arguments \"\$$index\""
  done
  eval "set -- $arguments"
}

subshell_basic_pop() {
  local index=0
  local arguments=""
  while [ $index -lt $(($1-1)) ]; do
    index=$((index+1))
    arguments="$arguments \"\$$index\""
  done
  echo "$arguments"
}

test_subshell_basic_pop() {
  eval "set -- $(subshell_basic_pop $#)"
  echo "$@"
}



