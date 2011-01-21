#include <string.h>

void reverse(char str[]){
  int first = 0, last = 0;
  char temp = 0;

  last = strlen(str) - 1;
  while( first <= last ){
    temp = str[first];
    str[first++] = str[last];
    str[last--] = temp;
  }
}
