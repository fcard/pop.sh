main() {
  mkdir -p popfun
  sh popgen.sh -p basic -o popfun/basic.sh
  sh popgen.sh -p posix -g1 -t1000 -o popfun/posix.sh
  sh popgen.sh -p g100 -x9 -g10,100 -o popfun/g100.sh
  sh popgen.sh -p ctool -x9 -g10 -c -t1000 -o popfun/ctool.sh
  sh popgen.sh -p tool -x9 -g10 -t1000 -o popfun/tool.sh
  sh popgen.sh -p pure_tool -t0 -o popfun/pure_tool.sh
  sh popgen.sh -p pure_ctool -t0 -c -o popfun/pure_ctool.sh

  cat popfun/* >popfunctions_all.sh
  rm -r popfun

  sh popgen.sh -p subarray -@ -+ -w -o popfunctions_array.sh

  mkdir -p popext
  sh popgen.sh -p g100_ext -x9 -g10,100 -+ -o popext/g100_ext.sh
  sh popgen.sh -p basic_ext -+ -o popext/basic_ext.sh
  cat popext/* >popfunctions_ext.sh
  rm -r popext
}

main "$@"
