#include <stdlib.h>
#include <stdio.h>

#define MAX_STR 255

void remove_char(char, char[]);
void do_remove_char(char, char[]);

int main(){
  char str[MAX_STR + 1];
  char rm_char;
  
  scanf("%c %255s",&rm_char, str);
  remove_char(rm_char, str);
  printf("%s", str);
  return 0;
}

/*start_prototype*/
void remove_char(char c, char str[]){
  
  /*your code here*/
  
}
/*end_prototype*/

void do_remove_char(char remove_char, char str[]){
  int write_index = 0;
  int read_index  = 0;
  char curr_char;
  
  do{
    curr_char = str[read_index];
    if(curr_char != remove_char){
      str[write_index] = str[read_index];
      write_index++;
    }
    read_index++;
  }while(curr_char);
}
