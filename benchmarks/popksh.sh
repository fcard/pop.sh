convert_to_ksh() {
  for file in popksh.sh "$@"; do
    convert_file_to_ksh "$file"
  done
}

convert_file_to_ksh() {
  sed '{
    s/\(^[ ]*[a-zA-Z0-9_]\+\)()[ ]*{/function \1 {/;
    s/\(^[ ]*\)\. \(.*\)/\1. <(convert_file_to_ksh \2)/;
  }' "$1"
}

handle_ksh() {
  local shell="$1"
  shift
  if [ "$shell" = ksh ]; then
    convert_to_ksh "$@"
  else
    cat "$@"
  fi
}

