#include <stdio.h>
#include <string.h>

#define MAX_STR 255

void remove_from_str(char[], char[]);

int main(){
  char str[MAX_STR + 1] = {'\0'};
  char remove_chars[MAX_STR + 1] = {'\0'}; 

  scanf("%255s %255s",remove_chars, str);
  remove_from_str(remove_chars, str);
  str[MAX_STR] = '\0';                     /*Always null terminated*/
  printf("%s", str);
  return 0;
}

/*start_prototype*/
void remove_from_str(char remove_chars[], char str[]){

  /*your code here*/
  
}
/*end_prototype*/
