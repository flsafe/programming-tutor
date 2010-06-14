#include <stdlib.h>
#include <stdio.h>

void remove_char(char, char[]);
void do_remove_char(char, char[]);

int main(int argc, char* argv[]){
  char *str;
  char remove;
  int str_size;
  
  int write, read;
	
	if(argc < 2){
		printf("Not enough arguments\n");
		return 1;
	}

  remove   = *argv[1];
  str_size = argc - 2;

  str      = malloc(sizeof(char) * str_size + 1);
	for(write = 0, read = 2 ; write < str_size; write++, read++)
    str[write] = *argv[read];
	str[write] = 0;

  remove_char(remove, str);
  printf("%s", str);
  
  return 0;
}

void remove_char(char c, char str[]){
 <SRC_CODE>
}

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
