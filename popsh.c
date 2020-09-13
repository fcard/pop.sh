#include "stdlib.h"
#include "stdio.h"

size_t int_log10(size_t x) {
  if (x < 10) {
    return 0;

  } else if (x < 100) {
    return 1;

  } else if (x < 1000) {
    return 2;

  } else if (x < 10000) {
    return 3;

  } else if (x < 100000) {
    return 4;

  } else if (x < 1000000) {
    return 4;

  } else if (x < 10000000) {
    return 5;

  } else if (x < 100000000) {
    return 6;

  } else {
    fprintf(stderr, "Too many arguments to pop!");
    exit(1);
  }
}

int main(int argc, char** argv) {
  if (argc == 2) {
    size_t length;
    sscanf(argv[1], "%zd", &length);

    size_t numlength = int_log10(length) + 1;
    size_t resultlen = length * (6 + numlength) + 1;

    char* result = malloc(sizeof(char) * resultlen);
    char* ptr = result;

    int n = 0;
    for (size_t i = 1; i < length; i++, ptr += n+1) {
      n = sprintf(ptr, "\"${%zd}\"", i);
      *(ptr+n)=' ';
    }

    printf("%s", result);
  }
}
