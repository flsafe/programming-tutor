#include <stdio.h>

/* When in production mode runing in Fedora Linux,
 * we use SECCOMP to limit what system calls can be made.
 * Otherwise we assume we are running on a development box
 * with no need for SECCOMP. */

#ifdef LINUX_SECCOMP
  #include<sys/prctl.h>
  #include<linux/prctl.h>
#endif

#define MAX_STR 255

void remove_char(char, char[]);
void do_remove_char(char, char[]);

int main(){
  char str[MAX_STR + 1];
  char rm_char;

  #ifdef LINUX_SECCOMP  
  prctl(PR_SET_SECCOMP, 1);
  #endif

  scanf("%c %255s",&rm_char, str);
  remove_char(rm_char, str);
  printf("%255s", str);
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
