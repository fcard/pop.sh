# Introduction

Utilities relating to removing the last argument from the parameter list in *nix shells

# pop.sh

A basic function that serves my purposes. It's used like this:

```sh
pop1() {
  pop $#
  eval "$POP_EXPR"
  echo "$@"
}

pop2() {
  pop $# 2
  eval "$POP_EXPR"
  echo "$@"
}

pop1 a b c #=> a b
pop1 $(seq 1 1000) #=> 1 .. 999
pop2 $(seq 1 1000) #=> 1 .. 998
```

It also contains a `pop_next` function:

```sh
main() {
  pop $#
  pop_next
  eval "$POP_EXPR"
}

main 1 2 3 #=> 1
```

# popgen.sh

`popgen.sh` is a script that can generate `pop` and `pop_next` functions
based on certain parameters.

One of the ways to improve performance without using external tools here is
to realize that having several small string concatenations is slow, so doing
them in batches makes the function considerably faster. calling the script
`popgen.sh -gN1,N2,N3` creates a pop function that handles the operations
in batches of N1, N2, or N3 depending on the argument count. The script also
contains other tricks, exemplified and explained below:

```sh
$ sh popgen  \
>  -g 10,100 \ # concatenate strings in batches\
>  -w        \ # overwrite current file\
>  -x9       \ # hardcode the result of the first 9 argument counts\
>  -t1000    \ # starting at argument count 1000, use external tools\
>  -p posix  \ # prefix to add to the function name (with a underscore)\
>  -s ''     \ # suffix to add to the function name (with a underscore)\
>  -c        \ # use the command popsh instead of seq/sed as the external tool\
>  -@        \ # on zsh and bash, use the subarray method (checks on runtime)\
>  -+        \ # use bash/zsh extensions (removes runtime check from -@)\
>  -nl       \ # don't use 'local'\
>  -f        \ # use 'function' syntax\
>  -o pop.sh   # output file
```

An equivalent to the `pop.sh` functions can be generated with `popgen.sh -t500 -g1 -@`.

# popsh.c

The `popsh.c` file that can be compiled and used as a specialized,
faster alternative to the default shell external tools, it will be used by
any function generated with`popgen.sh -c ...` if it's accessible as `popsh`
by the shell. Alternatively, you can create any function or tool named
`popsh` and use it in its place.

it can be compiled simply as:

```sh
$ gcc popsh.c -o popsh # or using any c99 compatible compiler
```

# Benchmark

## Benchmark functions:

The script I used for benchmarking can be found here:
https://github.com/fcard/pop.sh/blob/master/benchmarks/popbench.sh

The benchmark functions are found in these lines:
https://github.com/fcard/pop.sh/blob/master/benchmarks/popbench.sh#L233-L301

The script can be used as such:
```sh
$ sh popbench.sh   \
>   -s dash        \ # shell used by the benchmark, can be dash/bash/ash/zsh/ksh.\
>   -f posix       \ # function to be tested\
>   -i 10000       \ # number of times that the function will be called per test\
>   -a '\0'        \ # replacement pattern to model arguments by index (uses sed)\
>   -o /dev/stdout \ # where to print the results to (concatenates, defaults to stdout)\
>   -n 5,10,1000     # argument sizes to test
```
It will output a `time -p` style sheet with a `real`, `user` and `sys` time values,
as well as an `int` value, for internal, that is calculated inside the benchmark
process using `date`.

## Times

The following are the `int` results of calls to
```sh
$ sh popbench.sh -s $shell -f $function -i 10000 -n 1,5,10,100,1000,10000
```
`posix` refers to the second and third clauses, `subarray` refers to the first,
while `final` refers to the whole.

```sh
value count 	      1 	      5 	     10 	    100 	   1000 	   10000
---------------------------------------------------------------------------------------
dash/final  	  0m0.109s	  0m0.183s	  0m0.275s	  0m2.270s	 0m16.122s	 1m10.239s
ash/final   	  0m0.104s	  0m0.175s	  0m0.273s	  0m2.337s	 0m15.428s	 1m11.673s
ksh/final   	  0m0.409s	  0m0.557s	  0m0.737s	  0m3.558s	 0m19.200s	 1m40.264s
bash/final  	  0m0.343s	  0m0.414s	  0m0.470s	  0m1.719s	 0m17.508s	 3m12.496s
---------------------------------------------------------------------------------------
bash/subarray	  0m0.135s	  0m0.179s	  0m0.224s	  0m1.357s	 0m18.911s	 3m18.007s
dash/posix  	  0m0.171s	  0m0.290s	  0m0.447s	  0m3.610s	 0m17.376s	  1m8.852s
ash/posix   	  0m0.109s	  0m0.192s	  0m0.285s	  0m2.457s	 0m14.942s	 1m10.062s
ksh/posix   	  0m0.416s	  0m0.581s	  0m0.768s	  0m4.677s	 0m18.790s	 1m40.407s
bash/posix  	  0m0.409s	  0m0.739s	  0m1.145s	 0m10.048s	 0m58.449s	40m33.024s
```
## On zsh

For large argument counts setting `set -- ...` with eval is very slow on zsh no
matter no matter the method, save for `eval 'set -- "${@:1:$# - 1}"'`. Even as
simple a modification as changing it to `eval "set -- ${@:1:$# - 1}"`
(ignoring that it doesn't work for arguments with spaces) makes it two orders
of magnitude slower.

```sh
value count 	      1 	      5 	     10 	    100 	   1000 	   10000
---------------------------------------------------------------------------------------
zsh/subarray	  0m0.203s	  0m0.227s	  0m0.233s	  0m0.461s	  0m3.643s	 0m38.396s
zsh/final   	  0m0.399s	  0m0.416s	  0m0.441s	  0m0.722s	  0m4.205s	 0m37.217s
zsh/posix   	  0m0.718s	  0m0.913s	  0m1.182s	  0m6.200s	 0m46.516s	42m27.224s
zsh/eval-zsh	  0m0.419s	  0m0.353s	  0m0.375s	  0m0.853s	  0m5.771s	32m59.576s
```

## More benchmarks

For more benchmarks, including only using external tools, the c popsh tool
or the naive algorithm, see this file:

https://github.com/fcard/pop.sh/blob/master/benchmarks/benchmarks.md

It's generated like this:

```sh
$ git clone https://github.com/fcard/pop.sh
$ cd pop.sh/benchmarks
$ sh popgen_run.sh
$ sh popbench_run.sh --fast # or without --fast if you have a day to spare
$ sh poptable.sh -g >benchmarks.md
```


