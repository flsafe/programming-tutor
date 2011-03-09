#include <stdio.h>

#define MAX 100
#define START 1

void fizzbuzz(){
  int i;

  for (i = START ; i <= MAX ; i++){
    if (i % 15 == 0)
      printf("%s\n", "fizzbuzz");
    else if (i % 3 == 0)
      printf("%s\n", "fizz");
    else if (i % 5 == 0)
      printf("%s\n", "buzz");
    else
      printf("%d\n", i);
  }
}

