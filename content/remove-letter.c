#include <stdio.h>
#include <string.h>

#define MAX_STR 255

void remove_char(char, char[]);

int main(){
  char str[MAX_STR + 1];
  char rm_char; 
  memset(str, '\0', (MAX_STR + 1) * sizeof(char));

  scanf("%c %255s",&rm_char, str);

  remove_char(rm_char, str);

  str[MAX_STR] = '\0'; /*Always null terminated*/
  printf("%s", str);
  return 0;
}

/*start_prototype*/
void remove_char(char c, char str[]){
  
  /*your code here*/
  
}
/*end_prototype*/
