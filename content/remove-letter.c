#include <stdio.h>
#include <string.h>
#include "cozy_template_utils.h"

#define MAX_STR 255

void remove_char(char, char[]);

int main(){
  char str[MAX_STR + 1];
  char rm_char; 
  memset(str, '\0', (MAX_STR + 1) * sizeof(char));

  scanf("%c %255s",&rm_char, str);

  cozy1B9yZp_start_ignore_out();
  remove_char(rm_char, str);
  cozy1B9yZp_stop_ignore_stdout();

  str[MAX_STR] = '\0'; /*Always null terminated*/
  printf("%s", str);
  return 0;
}

/*
 * This is where the user solution code is inserted. 
 * The user solution code is run through the ../lib/IncludeScrubber
 * in the ruby file grade_solution_job.rb
 * to get rid of any user includes. Therefore it is important to include
 * any libs that will be needed above
 */

/*start_prototype*/
void remove_char(char c, char str[]){
  
  /*your code here*/
  
}
/*end_prototype*/
