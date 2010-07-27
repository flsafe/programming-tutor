#include <stdio.h>

void remove_char(char c, char str[]){
  int write_index = 0;
  int read_index  = 0;
  char curr_char;
  
  do{
    curr_char = str[read_index];
    if(curr_char != c){
      str[write_index] = str[read_index];
      write_index++;
    }
    read_index++;
  }while(curr_char != '\0');
}