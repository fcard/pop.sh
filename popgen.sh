#!/usr/bin/env sh

main() {
  local generate_pop=true genpop_out='' prefix='' suffix='' batches=1
  local overwrite=false print=false enhanced=false ctool=false cases=0 tools_at=''
  local subarray=false nolocal=false funct=false

  set_batches() {
    batches="$(echo "$1" | sed -e 's/,/ /g')"
    for n in $batches; do
      set_number '' "$n" || batches=''
    done
  }

  set_number() {
    case "$2" in
      ''|*[!0-9]*) echo "error: argument not a number: $2" >&2; return 1 ;;
      *) [ -n "$1" ] && eval "$1=$2" ;;
    esac
    return 0
  }

  set_number_list() {
    case "$2" in
      ''|*[!0-9,]*) echo "error: argument not a number list: $2" >&2; return 1 ;;
      *) [ -n "$1" ] && eval "$1='$(echo "$2" | sed 's/,/ /g')'" ;;
    esac
    return 0
  }

  set_name() {
    case "$2" in
      *[!a-zA-Z0-9_]*) echo "error: argument not a name: $2" >&2 ;;
      *) eval "$1=$2" ;;
    esac
  }

  set_prefix() {
    case "$1" in
      [0-9]*) echo "error: prefix cannot start with number: $1" >&2 ;;
      *) set_name prefix "$1" ;;
    esac
  }

  while [ $# -gt 0 ]; do
    case "$1" in
      --groups)
        set_number_list batches "$2"
        shift 2
        ;;

      --generate-pop=*)
        set_number_list batches "${1#--generate-pop=}"
        shift
        ;;

      --generate-pop|-g)
        set_number_list batches "$2"
        shift 2
        ;;

      -g*)
        set_number_list batches "${1#-g}"
        shift
        ;;

      --tools=*)
        set_number tools_at "${1#--tools=}"
        shift
        ;;

      --tools|-t)
        set_number tools_at "$2"
        shift 2
        ;;

      -t*)
        set_number tools_at "${1#-t}"
        shift
        ;;

      --ctool|-c)
        ctool=true
        shift
        ;;

      --cases=*)
        set_number cases "${1#--cases=}"
        shift
        ;;

      --cases|-x)
        set_number cases "$2"
        shift 2
        ;;

      -x*)
        set_number cases "${1#-x}"
        shift
        ;;

      --print|-e)
        print=true
        shift
        ;;

      --prefix=*)
        set_prefix "${1#--prefix=}"
        shift
        ;;

      --prefix|-p)
        set_prefix "$2"
        shift 2
        ;;

      -p*)
        set_prefix "${1#-p}"
        shift
        ;;

      --suffix=*)
        set_name suffix "${1#--suffix=}"
        shift
        ;;

      --suffix|-s)
        set_name suffix "$2"
        shift 2
        ;;

      -s*)
        set_name suffix "${1#-s}"
        shift
        ;;

      --generate-to=*)
        genpop_out="${1#--generate-to}"
        shift
        ;;

      --generate-to|-o)
        genpop_out="$2"
        shift 2
        ;;

      -o*)
        genpop_out="${1#-o}"
        shift
        ;;

      --enhanced|-+)
        enhanced=true
        shift
        ;;

      --overwrite|-w)
        overwrite=true
        shift
        ;;

      --subarray|-@)
        subarray=true
        shift
        ;;

      --no-local|-nl)
        nolocal=true
        shift
        ;;

      --function|-f)
        funct=true
        shift
        ;;

      *)
        echo "invalid argument: $1"
        shift
        ;;
    esac
  done

  if $generate_pop; then
    prefix="$prefix${prefix:+_}"
    suffix="${suffix:+_}$suffix"

    gen() {
      generate_pop -@ $subarray -t "$tools_at" -c "$ctool" -x "$cases"\
                   -p "$prefix" -s "$suffix" -e "$enhanced" -nl $nolocal\
                   -f "$funct" $batches
    }

    if $print; then
      printf '%s\n' "$(gen)"
    else
      genpop_out="${genpop_out:-${prefix}pop$suffix.sh}"
      if [ -f "$genpop_out" ] && ! $overwrite; then
        echo "error: file $genpop_out already exists!"
      else
        gen >"$genpop_out"
      fi
    fi
  fi
}


NL="
"

DefaultTest='
test_<pop>() {
  <pop> $#
  eval "$POP_EXPR"
  echo "$@"
}
'

BasicPopCode=\
'  <local>index=0
  <local>arguments=""
  while [ $index -lt $((n - 1)) ]; do
    index=$((index+1))
    arguments="$arguments \"\${$index}\""
  done
  POP_EXPR="set -- $arguments"'

EnhancedBasicPopCode=\
'  <local>arguments=""
  for (( index=1; index < n; index++ )) do
    arguments+=" \"\${$index}\""
  done
  POP_EXPR="set -- $arguments"'

BasicPop='
<pop>() {
  <local>n=$(($1 - ${2:-1} + 1))
'"$BasicPopCode"'
}
'"$DefaultTest"'
'


EnhancedBasicPop='
<function><pop><parens> {
  <local>n=$(($1 - ${2:-1} + 1))
'"$EnhancedBasicPopCode"'
}
'"$DefaultTest"'
'

Batch1='
<function><pop><parens> {
  <local>n="$1"
'"$BasicPopCode"'
}
'

EnhancedBatch1='
<function><pop><parens> {
  <local>n="$1"
'"$EnhancedBasicPopCode"'
}
'

SubArrayPop='
<function><pop><parens> {
  POP_EXPR="set -- \"\${@:1:$1 - ${2:-1}}\""
}

<function>test_<pop><parens> {
  set -- "${@:1:$# - 1}"
  echo "$@"
}
'


SedExpr='s/[0-9]\+/"${\0}"/g'
SedCall='$(seq -s " " 1 $((n - 1)) | sed '"'$SedExpr')"

ToolPop='
<function><pop><parens> {
  <local>n=$(($1 - ${2:-1} + 1))
  POP_EXPR="set -- '"$SedCall"'"
}
'"$DefaultTest"'
'


CToolPop='
<function><pop><parens> {
  <local>n=$(($1 - ${2:-1} + 1))
  POP_EXPR="set -- $(popsh $n)"
}
'"$DefaultTest"'
'


generate_pop_batch() {
  local batch="$1"
  local enhanced=${2:-false}
  local prefix="$3" suffix="$4"
  local nolocal="$5"
  local functsyn="$6"

  local funct='' parens='()'
  if $functsyn; then
    funct='function '
    parens=''
  fi

  local loc='local ' nl_semicolon=''
  if $nolocal; then
    loc=''
    nl_semicolon=';'
  fi

  premade_batch() {
    printf '%s\n' "$1" | sed "{
      s/<pop>/batch_${prefix}pop$suffix$batch/g;
      s/<local>/$loc/g;
      s/<function>/$funct/g;
      s/<parens>/$parens/g;
    }"
  }


  if [ $batch -eq 1 ]; then
    if $enhanced; then
      premade_batch "$EnhancedBatch1"
    else
      premade_batch "$Batch1"
    fi
    return
  fi

  local code=''

  args() {
    local str="$(for x in $(seq 1 $1); do printf ' \\"\\${$i%d}\\"' $x; done)"
    if $enhanced; then
      echo "arguments+=\"$str\""
    else
      echo "arguments=\"\$arguments $str\""
    fi
  }
  casex() {
    printf '    %d) %s ;;\n' $x "$(args $((x-1)))"
  }
  indexes() {
    for x in $(seq 1 $batch); do
      printf ' i%d=%d%s' $x $x "$nl_semicolon"
    done
  }
  local funcname="${funct}batch_${prefix}pop$suffix$batch$parens"
  local index_decl="${loc}index=0$nl_semicolon$(indexes)"
  local set_ls="$(for x in $(seq 1 $batch); do printf '    i%d=$((index+%d))\n' $x $x; done)"
  local while_less="while [ \$index -lt \$((n-$batch)) ]; do$NL    $(args $batch)$NL"
  while_less="${while_less}    index=\$i$batch$NL"
  while_less="${while_less}$set_ls$NL  done"

  local cases="$(for x in $(seq 2 $((batch-1))); do casex $x; done)"
  cases="$cases$NL    0) $(args $((batch-1))) ;;$NL  esac"
  local cases_rem='case $((n%'$batch')) in'"$NL$cases"

  code="$funcname {"
  code="$code$NL  ${loc}n=\"\$1\""
  code="$code$NL  ${loc}arguments=''"
  code="$code$NL  $index_decl"
  code="$code$NL  $while_less"
  code="$code$NL  $cases_rem"
  code="$code$NL  POP_EXPR=\"set -- \$arguments\""
  code="$code$NL}"
  code="$code$NL"

  printf '%s\n' "$code"
}

SubarrayPopNext=\
'  <local>np="${POP_EXPR##*:}"
  np="${np%\}*}"
  POP_EXPR="${POP_EXPR%:*}:$((np == 0 ? 0 : np - 1))}\""
'

generate_pop_next() {
  local prefix="$1" suffix="$2" subarray="$3" enhanced="$4" funct="$5" parens="$6" loc="$7"
  local code="${funct}${prefix}pop${suffix}_next$parens {"

  if $subarray; then
    subarray_code="$(printf '%s' "$SubarrayPopNext" | sed "s/<local>/$loc/g")"

    if $enhanced; then
      code="$code$NL$subarray_code"
      code="$code$NL}"
      printf '%s' "$code"
      return
    else
      code="$code$NL  if [ -n \"\$BASH_VERSION\" -o -n \"\$ZSH_VERSION\" ]; then"
      code="$code$NL$(printf '%s' "$subarray_code" | sed 's/^/  /')"
      code="$code$NL    return"
      code="$code$NL  fi"
    fi
  fi
  code="$code$NL  POP_EXPR=\"\${POP_EXPR% \\\"*}\""
  code="$code$NL}"
  printf '%s\n\n' "$code"
}


generate_test() {
  local prefix="$1" suffix="$2" funct="$3" parens="$4" code=''
  code="${funct}test_${prefix}pop$suffix$parens {"
  code="$code$NL  ${prefix}pop$suffix \$#"
  code="$code$NL  eval \"\$POP_EXPR\""
  code="$code$NL  echo \"\$@\""
  code="$code$NL}"
  code="$code$NL"

  printf '%s\n' "$code"
}

reverse_sort() {
  echo "$*" | tr ' ' '\n' | sort -n -u -r
}

generate_pop() {
  local code=''
  local read_args=true prefix='' suffix='' tools='' ctool=false
  local casenum=0 enhanced=false subarray=false nolocal=false
  local functsyn=false
  while $read_args; do
    case "$1" in
      -x)
        casenum="$2"
        shift 2
        ;;

      -@)
        subarray="$2"
        shift 2
        ;;

      -s)
        suffix="$2"
        shift 2
        ;;

      -p)
        prefix="$2"
        shift 2
        ;;

      -c)
        ctool="$2"
        shift 2
        ;;

      -t)
        tools="$2"
        shift 2
        ;;

      -e)
        enhanced="$2"
        shift 2
        ;;

      -nl)
        nolocal="$2"
        shift 2
        ;;

      -f)
        functsyn="$2"
        shift 2
        ;;

      *)
        read_args=false
        ;;
    esac
  done

  local funct='' parens='()'
  if $functsyn; then
    funct='function '
    parens=''
  fi

  local loc='local '
  if $nolocal; then
    loc=''
  fi

  premade_pop() {
    printf '%s\n' "$1" | sed "{
      s/<pop>/${prefix}pop$suffix/g;
      s/<local>/$loc/g;
      s/<function>/$funct/g;
      s/<parens>/$parens/g;
    }"
    generate_pop_next "$prefix" "$suffix" "$subarray" "$enhanced" "$funct" "$parens" "$loc"
  }

  if $enhanced && $subarray; then
    premade_pop "$SubArrayPop"
    return
  elif [ "$tools" = 0 ]; then
    if $ctool; then
      premade_pop "$CToolPop"
    else
      premade_pop "$ToolPop"
    fi
    return
  elif [ "$batches" = 1 -a "$casenum" = 0 -a -z "$tools" ] && ! $subarray; then
    if $enhanced; then
      premade_pop "$EnhancedBasicPop"
    else
      premade_pop "$BasicPop"
    fi
    return
  fi

  local sed_expr tool_call tool_set
  local CI=''

  if [ $casenum -gt 0 ]; then
    CI='    '
  fi

  if $ctool; then
    tool_call='$(popsh $n)'
  else
    tool_call="$SedCall"
  fi
  tool_set="POP_EXPR=\"set -- $tool_call\""

  local clauses=''
  if [ $# -eq 1 ]; then
    generate_pop_batch "$1" "$enhanced" "$prefix" "$suffix" "$nolocal" "$functsyn"

    if [ -n "$tools" ]; then
      clauses="if [ \$1 -ge $tools ]; then"
      clauses="$clauses$NL$CI    $tool_set"
      clauses="$clauses$NL$CI  else"
      clauses="$clauses$NL$CI    batch_${prefix}pop$suffix$1 \$n"
      clauses="$clauses$NL$CI  fi"
    else
      clauses="batch_${prefix}pop$suffix$1 \$n"
    fi
  else
    local i=1
    for batch in $(reverse_sort "$*"); do
      generate_pop_batch "$batch" "$enhanced" "$prefix" "$suffix" "$nolocal" "$functsyn"
      if [ $i -lt $# ]; then
        clauses="$clauses"${clauses:+$NL$CI  el}'if [ $n -ge '"$batch"' ]; then'
      else
        clauses="$clauses$NL$CI  else"
      fi
      clauses="$clauses$NL$CI    batch_${prefix}pop$suffix$batch \$n"
      i=$((i+1))
    done
    clauses="$clauses$NL$CI  fi"
    if [ -n "$tools" ]; then
      local tool_clause
      tool_clause="if [ \$n -ge $tools ]; then"
      tool_clause="$tool_clause$NL$CI    $tool_set"
      clauses="$tool_clause$NL$CI  el$clauses"
    fi
  fi

  code="${funct}${prefix}pop$suffix$parens {"
  code="$code$NL  ${loc}n=\$((\$1 - \${2:-1} + 1))"

  if $subarray; then
    code="$code$NL  if [ -n \"\$BASH_VERSION\" -o -n \"\$ZSH_VERSION\" ]; then"
    code="$code$NL    POP_EXPR='set -- \"\${@:1:'\$((n - 1))'}\"'"
    code="$code$NL    return"
    code="$code$NL  fi"
  fi

  if [ $casenum -gt 0 ]; then
    args() {
      seq -s ' ' 1 "$(($1 - 1))" | sed 's/[0-9]\+/"${\0}"/g'
    }

    local cases=''
    for c in $(seq 1 $casenum); do
      cases="$cases${cases:+$NL}    $c) POP_EXPR='set -- $(args $c)' ;;"
    done

    code="$code$NL  case \$n in$NL$cases"
    code="$code$NL    *)"
    code="$code$NL      $clauses"
    code="$code$NL      ;;"
    code="$code$NL  esac"
  else
    code="$code$NL  $clauses"
  fi
  code="$code$NL}"
  code="$code$NL"
  printf '%s\n' "$code"

  generate_pop_next "$prefix" "$suffix" "$subarray" "$enhanced" "$funct" "$parens" "$loc"
  generate_test "$prefix" "$suffix" "$funct" "$parens"
}


main "$@"
