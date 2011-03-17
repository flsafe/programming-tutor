#include <stdio.h>
#include <string.h>

#define MAX_STR 255

void reverse(char[]);

int main(){
  char str[MAX_STR + 1] = {'\0'};

  scanf("%255s", str);
  reverse(str);
  str[MAX_STR] = '\0';                     /*Always null terminated*/
  printf("%s", str);
  return 0;
}

/*start_prototype*/
void reverse(char str[]){

  /*your code here*/
  
}
/*end_prototype*/
