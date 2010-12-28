#include <stdio.h>
#include <strings.h>

/* When in production mode runing in Fedora Linux,
 * we use the SECCOMP flag to limit system resources.
 * Otherwise we assume we are running on a development box
 * with no need for SECCOMP. */

#ifdef LINUX_SECCOMP
  #include<sys/time.h>
  #include<sys/resource.h>
#endif

#define MAX_STR 255

#ifdef LINUX_SECCOMP
  void set_limit(int resource, int value){         
    struct rlimit rl;
                  
    getrlimit(resource, &rl);
    rl.rlim_cur = value;
    rl.rlim_max = value;
    setrlimit(resource, &rl);
  }
#endif

void remove_char(char, char[]);

int main(){
  char str[MAX_STR + 1];
  char rm_char; 
  bzero(str, MAX_STR + 1);

  #ifdef LINUX_SECCOMP 
    set_limit(RLIMIT_CPU, 4); 
    set_limit(RLIMIT_NOFILE, 0); 
    set_limit(RLIMIT_FSIZE, 1); 
    set_limit(RLIMIT_NPROC, 1);  
    set_limit(RLIMIT_DATA, 100000); 
    set_limit(RLIMIT_STACK, 100000); 
    set_limit(RLIMIT_AS, 100000); 
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
