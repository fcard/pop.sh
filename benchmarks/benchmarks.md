# All Times

Generated with
```sh
$ sh popbench_run.sh --fast
```
This simulates calling each function 10000 times with each argument count.

| value counts       |           1 |           5 |          10 |         100 |        1000 |       10000 |
| :----------------- | ----------: | ----------: | ----------: | ----------: | ----------: | ----------: |
| `bash/subarray`    |   0m 0.157s |   0m 0.203s |   0m 0.244s |   0m 1.475s |   0m19.543s |   3m26.949s |
| `zsh/subarray`     |   0m 0.225s |   0m 0.246s |   0m 0.248s |   0m 0.486s |   0m 3.868s |   0m41.325s |
| `bash/bash-unset`  |   0m 0.907s |   0m 0.774s |   0m 0.818s |   0m 2.401s |   0m19.370s |   3m15.918s |
| `zsh/zsh-unset`    |   0m 0.745s |   0m 0.576s |   0m 0.532s |   0m 0.778s |   0m 4.707s |   0m41.935s |
| `dash/basic`       |   0m 0.149s |   0m 0.290s |   0m 0.336s |   0m 4.077s |   1m 3.991s |  69m10.859s |
| `ash/basic`        |   0m 0.143s |   0m 0.226s |   0m 0.372s |   0m 2.986s |   0m57.807s |  69m 5.373s |
| `ksh/basic`        |   0m 0.394s |   0m 0.689s |   0m 0.874s |   0m 4.918s |   0m53.345s |  16m26.308s |
| `bash/basic`       |   0m 1.935s |   0m 1.330s |   0m 2.069s |   0m11.108s |   6m36.475s | 523m 2.542s |
| `zsh/basic`        |   0m 0.717s |   0m 0.988s |   0m 1.178s |   0m 6.176s |   2m38.037s | 223m54.796s |
| `ksh/basic-ext`    |   0m 0.341s |   0m 0.425s |   0m 0.556s |   0m 2.349s |   0m19.849s |   4m38.749s |
| `bash/basic-ext`   |   0m 0.610s |   0m 0.754s |   0m 0.862s |   0m 6.006s |   1m14.119s |  50m30.017s |
| `zsh/basic-ext`    |   0m 0.491s |   0m 0.661s |   0m 0.771s |   0m 2.764s |   0m55.845s |  53m24.479s |
| `dash/final`       |   0m 0.332s |   0m 0.218s |   0m 0.268s |   0m 2.306s |   0m15.492s |   1m12.351s |
| `ash/final`        |   0m 0.111s |   0m 0.192s |   0m 0.325s |   0m 2.575s |   0m16.449s |   1m10.999s |
| `ksh/final`        |   0m 0.384s |   0m 0.518s |   0m 0.754s |   0m 3.942s |   0m21.462s |   1m45.162s |
| `bash/final`       |   0m 0.369s |   0m 0.433s |   0m 0.606s |   0m 1.936s |   0m18.432s |   3m16.546s |
| `zsh/final`        |   0m 0.423s |   0m 0.449s |   0m 0.423s |   0m 0.673s |   0m 3.728s |   0m36.444s |
| `bash/g100`        |   0m 0.329s |   0m 0.430s |   0m 1.057s |   0m 5.813s |   1m14.039s |  50m27.588s |
| `dash/g100`        |   0m 0.101s |   0m 0.102s |   0m 0.213s |   0m 1.285s |   0m10.952s |   2m32.395s |
| `ash/g100`         |   0m 0.094s |   0m 0.106s |   0m 0.232s |   0m 1.194s |   0m10.938s |   2m31.385s |
| `ksh/g100`         |   0m 0.280s |   0m 0.310s |   0m 0.717s |   0m 2.502s |   0m24.781s |   4m22.427s |
| `zsh/g100`         |   0m 0.620s |   0m 0.492s |   0m 0.782s |   0m 3.061s |   1m13.832s |  89m13.652s |
| `bash/g100-ext`    |   0m 0.280s |   0m 0.383s |   0m 0.972s |   0m 5.780s |   1m10.797s |  45m42.810s |
| `ksh/g100-ext`     |   0m 0.276s |   0m 0.300s |   0m 0.643s |   0m 2.519s |   0m25.967s |   4m28.754s |
| `dash/posix`       |   0m 0.171s |   0m 0.290s |   0m 0.447s |   0m 3.610s |   0m17.376s |   1m 8.852s |
| `ash/posix`        |   0m 0.109s |   0m 0.192s |   0m 0.285s |   0m 2.457s |   0m14.942s |   1m10.062s |
| `ksh/posix`        |   0m 0.416s |   0m 0.581s |   0m 0.768s |   0m 4.677s |   0m18.790s |   1m40.407s |
| `bash/posix`       |   0m 0.409s |   0m 0.739s |   0m 1.145s |   0m10.048s |   0m58.449s |  40m33.024s |
| `zsh/posix`        |   0m 0.718s |   0m 0.913s |   0m 1.182s |   0m 6.200s |   0m46.516s |  42m27.224s |
| `bash/pure-tool`   |   0m13.420s |   0m17.283s |   0m14.500s |   0m20.177s |   0m58.152s |  39m41.456s |
| `dash/pure-tool`   |   0m12.053s |   0m11.008s |   0m15.362s |   0m12.033s |   0m20.204s |   1m 7.662s |
| `ash/pure-tool`    |   0m13.209s |   0m 9.390s |   0m 9.738s |   0m10.369s |   0m15.917s |   1m10.476s |
| `ksh/pure-tool`    |   0m10.223s |   0m11.032s |   0m10.549s |   0m11.457s |   0m19.668s |   1m40.265s |
| `zsh/pure-tool`    |   0m13.763s |   0m13.563s |   0m13.340s |   0m14.102s |   0m48.371s |  42m49.117s |
| `bash/pure-ctool`  |   0m 6.809s |   0m 6.859s |   0m 6.637s |   0m10.272s |   0m52.334s |  40m40.125s |
| `dash/pure-ctool`  |   0m 3.880s |   0m 3.827s |   0m 3.721s |   0m 4.357s |   0m 9.206s |   0m56.823s |
| `ash/pure-ctool`   |   0m 4.282s |   0m 4.066s |   0m 4.341s |   0m 4.752s |   0m 9.541s |   0m56.756s |
| `ksh/pure-ctool`   |   0m 6.318s |   0m 7.031s |   0m 6.486s |   0m 7.357s |   0m14.518s |   1m33.253s |
| `zsh/pure-ctool`   |   0m 5.951s |   0m 6.036s |   0m 6.081s |   0m 7.294s |   0m39.701s |  43m 7.165s |
| `bash/tool`        |   0m 0.283s |   0m 0.382s |   0m 0.896s |   0m 5.859s |   0m59.353s |  40m32.236s |
| `dash/tool`        |   0m 0.079s |   0m 0.104s |   0m 0.232s |   0m 1.163s |   0m15.033s |   1m 9.174s |
| `ash/tool`         |   0m 0.079s |   0m 0.096s |   0m 0.194s |   0m 1.166s |   0m15.887s |   1m 7.822s |
| `ksh/tool`         |   0m 0.298s |   0m 0.309s |   0m 0.834s |   0m 3.063s |   0m18.253s |   1m39.460s |
| `zsh/tool`         |   0m 0.683s |   0m 0.740s |   0m 1.249s |   0m 4.532s |   1m 5.296s |  42m57.209s |
| `bash/ctool`       |   0m 0.283s |   0m 0.362s |   0m 0.845s |   0m 5.529s |   0m51.037s |  39m 7.538s |
| `dash/ctool`       |   0m 0.086s |   0m 0.110s |   0m 0.186s |   0m 1.159s |   0m 9.371s |   0m55.712s |
| `ash/ctool`        |   0m 0.089s |   0m 0.096s |   0m 0.198s |   0m 1.219s |   0m 9.346s |   0m55.922s |
| `ksh/ctool`        |   0m 0.259s |   0m 0.290s |   0m 0.647s |   0m 3.156s |   0m13.438s |   1m30.011s |
| `zsh/ctool`        |   0m 0.441s |   0m 0.608s |   0m 1.039s |   0m 2.987s |   0m40.164s |  41m50.496s |


# Functions

## basic

The simplest function to compute the pop expression, uses a naive algorithm to
generate a list of parameters minus the last one.
```sh
$ sh popgen.sh
```
| value counts       |           1 |           5 |          10 |         100 |        1000 |       10000 |
| :----------------- | ----------: | ----------: | ----------: | ----------: | ----------: | ----------: |
| `dash`             |   0m 0.149s |   0m 0.290s |   0m 0.336s |   0m 4.077s |   1m 3.991s |  69m10.859s |
| `ash`              |   0m 0.143s |   0m 0.226s |   0m 0.372s |   0m 2.986s |   0m57.807s |  69m 5.373s |
| `ksh`              |   0m 0.394s |   0m 0.689s |   0m 0.874s |   0m 4.918s |   0m53.345s |  16m26.308s |
| `bash`             |   0m 1.935s |   0m 1.330s |   0m 2.069s |   0m11.108s |   6m36.475s | 523m 2.542s |
| `zsh`              |   0m 0.717s |   0m 0.988s |   0m 1.178s |   0m 6.176s |   2m38.037s | 223m54.796s |


## basic-ext

The same as basic but use bash/ksh/zsh extensions. Causes immense speed ups in
bash and ksh by using the `+=` operator instead of concatenating strings with `=`.
```sh
$ sh popgen.sh -+
```
| value counts       |           1 |           5 |          10 |         100 |        1000 |       10000 |
| :----------------- | ----------: | ----------: | ----------: | ----------: | ----------: | ----------: |
| `ksh`              |   0m 0.341s |   0m 0.425s |   0m 0.556s |   0m 2.349s |   0m19.849s |   4m38.749s |
| `bash`             |   0m 0.610s |   0m 0.754s |   0m 0.862s |   0m 6.006s |   1m14.119s |  50m30.017s |
| `zsh`              |   0m 0.491s |   0m 0.661s |   0m 0.771s |   0m 2.764s |   0m55.845s |  53m24.479s |


## posix

A function that is meant to be small but efficient on POSIX shells.
Uses the basic algorithm for arguments less than 500, otherwise use external tools.
```sh
$ sh popgen.sh -t500
```
| value counts       |           1 |           5 |          10 |         100 |        1000 |       10000 |
| :----------------- | ----------: | ----------: | ----------: | ----------: | ----------: | ----------: |
| `dash`             |   0m 0.171s |   0m 0.290s |   0m 0.447s |   0m 3.610s |   0m17.376s |   1m 8.852s |
| `ash`              |   0m 0.109s |   0m 0.192s |   0m 0.285s |   0m 2.457s |   0m14.942s |   1m10.062s |
| `ksh`              |   0m 0.416s |   0m 0.581s |   0m 0.768s |   0m 4.677s |   0m18.790s |   1m40.407s |
| `bash`             |   0m 0.409s |   0m 0.739s |   0m 1.145s |   0m10.048s |   0m58.449s |  40m33.024s |
| `zsh`              |   0m 0.718s |   0m 0.913s |   0m 1.182s |   0m 6.200s |   0m46.516s |  42m27.224s |


## subarray

Uses the subarray method of removing the last parameter, i.e. `set -- "${@:1:$# - 1}"`.
```sh
$ sh popgen.sh -+ -@
```
| value counts       |           1 |           5 |          10 |         100 |        1000 |       10000 |
| :----------------- | ----------: | ----------: | ----------: | ----------: | ----------: | ----------: |
| `bash`             |   0m 0.157s |   0m 0.203s |   0m 0.244s |   0m 1.475s |   0m19.543s |   3m26.949s |
| `zsh`              |   0m 0.225s |   0m 0.246s |   0m 0.248s |   0m 0.486s |   0m 3.868s |   0m41.325s |


## final

Combines subarray and posix, using the former for zsh and bash and the latter for the rest.
```sh
$ sh popgen.sh -@ -t500
```
| value counts       |           1 |           5 |          10 |         100 |        1000 |       10000 |
| :----------------- | ----------: | ----------: | ----------: | ----------: | ----------: | ----------: |
| `dash`             |   0m 0.332s |   0m 0.218s |   0m 0.268s |   0m 2.306s |   0m15.492s |   1m12.351s |
| `ash`              |   0m 0.111s |   0m 0.192s |   0m 0.325s |   0m 2.575s |   0m16.449s |   1m10.999s |
| `ksh`              |   0m 0.384s |   0m 0.518s |   0m 0.754s |   0m 3.942s |   0m21.462s |   1m45.162s |
| `bash`             |   0m 0.369s |   0m 0.433s |   0m 0.606s |   0m 1.936s |   0m18.432s |   3m16.546s |
| `zsh`              |   0m 0.423s |   0m 0.449s |   0m 0.423s |   0m 0.673s |   0m 3.728s |   0m36.444s |


## g100

Used to test an alternative to external tools, concatenating the strings in batches.
```sh
$ sh popgen.sh -x9 -g10,100
```
| value counts       |           1 |           5 |          10 |         100 |        1000 |       10000 |
| :----------------- | ----------: | ----------: | ----------: | ----------: | ----------: | ----------: |
| `bash`             |   0m 0.329s |   0m 0.430s |   0m 1.057s |   0m 5.813s |   1m14.039s |  50m27.588s |
| `dash`             |   0m 0.101s |   0m 0.102s |   0m 0.213s |   0m 1.285s |   0m10.952s |   2m32.395s |
| `ash`              |   0m 0.094s |   0m 0.106s |   0m 0.232s |   0m 1.194s |   0m10.938s |   2m31.385s |
| `ksh`              |   0m 0.280s |   0m 0.310s |   0m 0.717s |   0m 2.502s |   0m24.781s |   4m22.427s |
| `zsh`              |   0m 0.620s |   0m 0.492s |   0m 0.782s |   0m 3.061s |   1m13.832s |  89m13.652s |


## g100-ext

Same as `g100` but uses bash/ksh/zsh extensions, specifically the `+=` string concatenation.
```sh
$ sh popgen.sh -+ -x9 -g10,100
```
| value counts       |           1 |           5 |          10 |         100 |        1000 |       10000 |
| :----------------- | ----------: | ----------: | ----------: | ----------: | ----------: | ----------: |
| `bash`             |   0m 0.280s |   0m 0.383s |   0m 0.972s |   0m 5.780s |   1m10.797s |  45m42.810s |
| `ksh`              |   0m 0.276s |   0m 0.300s |   0m 0.643s |   0m 2.519s |   0m25.967s |   4m28.754s |


## tool

Combines batch concatenation with external tools. Merges all types of universal
optimizations for a complex but consistently speedy function.

```sh
$ sh popgen.sh -x9 -g10 -t1000
```
| value counts       |           1 |           5 |          10 |         100 |        1000 |       10000 |
| :----------------- | ----------: | ----------: | ----------: | ----------: | ----------: | ----------: |
| `bash`             |   0m 0.283s |   0m 0.382s |   0m 0.896s |   0m 5.859s |   0m59.353s |  40m32.236s |
| `dash`             |   0m 0.079s |   0m 0.104s |   0m 0.232s |   0m 1.163s |   0m15.033s |   1m 9.174s |
| `ash`              |   0m 0.079s |   0m 0.096s |   0m 0.194s |   0m 1.166s |   0m15.887s |   1m 7.822s |
| `ksh`              |   0m 0.298s |   0m 0.309s |   0m 0.834s |   0m 3.063s |   0m18.253s |   1m39.460s |
| `zsh`              |   0m 0.683s |   0m 0.740s |   0m 1.249s |   0m 4.532s |   1m 5.296s |  42m57.209s |


## ctool

Same as `tool` but uses the command `popsh` instead of `seq`/`sed`. This benchmark uses the implementation contained in `popsh.c`.

```sh
$ sh popgen.sh -x9 -g10 -t1000
```
| value counts       |           1 |           5 |          10 |         100 |        1000 |       10000 |
| :----------------- | ----------: | ----------: | ----------: | ----------: | ----------: | ----------: |
| `bash`             |   0m 0.283s |   0m 0.362s |   0m 0.845s |   0m 5.529s |   0m51.037s |  39m 7.538s |
| `dash`             |   0m 0.086s |   0m 0.110s |   0m 0.186s |   0m 1.159s |   0m 9.371s |   0m55.712s |
| `ash`              |   0m 0.089s |   0m 0.096s |   0m 0.198s |   0m 1.219s |   0m 9.346s |   0m55.922s |
| `ksh`              |   0m 0.259s |   0m 0.290s |   0m 0.647s |   0m 3.156s |   0m13.438s |   1m30.011s |
| `zsh`              |   0m 0.441s |   0m 0.608s |   0m 1.039s |   0m 2.987s |   0m40.164s |  41m50.496s |


## pure-tool

Uses only external tools. Has the advantage of being a one-liner but the disadvantage of a high overhead, so it's inefficient for low argument counts.
```sh
$ sh popgen.sh -t0
```
| value counts       |           1 |           5 |          10 |         100 |        1000 |       10000 |
| :----------------- | ----------: | ----------: | ----------: | ----------: | ----------: | ----------: |
| `bash`             |   0m13.420s |   0m17.283s |   0m14.500s |   0m20.177s |   0m58.152s |  39m41.456s |
| `dash`             |   0m12.053s |   0m11.008s |   0m15.362s |   0m12.033s |   0m20.204s |   1m 7.662s |
| `ash`              |   0m13.209s |   0m 9.390s |   0m 9.738s |   0m10.369s |   0m15.917s |   1m10.476s |
| `ksh`              |   0m10.223s |   0m11.032s |   0m10.549s |   0m11.457s |   0m19.668s |   1m40.265s |
| `zsh`              |   0m13.763s |   0m13.563s |   0m13.340s |   0m14.102s |   0m48.371s |  42m49.117s |


## pure-ctool

Same as pure-tool but uses `popsh`.
```sh
$ sh popgen.sh -c -t0
```
| value counts       |           1 |           5 |          10 |         100 |        1000 |       10000 |
| :----------------- | ----------: | ----------: | ----------: | ----------: | ----------: | ----------: |
| `bash`             |   0m 6.809s |   0m 6.859s |   0m 6.637s |   0m10.272s |   0m52.334s |  40m40.125s |
| `dash`             |   0m 3.880s |   0m 3.827s |   0m 3.721s |   0m 4.357s |   0m 9.206s |   0m56.823s |
| `ash`              |   0m 4.282s |   0m 4.066s |   0m 4.341s |   0m 4.752s |   0m 9.541s |   0m56.756s |
| `ksh`              |   0m 6.318s |   0m 7.031s |   0m 6.486s |   0m 7.357s |   0m14.518s |   1m33.253s |
| `zsh`              |   0m 5.951s |   0m 6.036s |   0m 6.081s |   0m 7.294s |   0m39.701s |  43m 7.165s |


