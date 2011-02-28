#include <string.h>

void reverse(char str[]){
  int first, last;
  char temp;

  if( ! str )
    return;

  last = strlen(str) - 1;
  first = 0;
  for(; first <= last ; first++, last--)
  {
    temp = str[first];
    str[first] = str[last];
    str[last] = temp;
  }
}
