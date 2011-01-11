#include <stdio.h>
#include <string.h>

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
                  
    rl.rlim_cur = value;
    rl.rlim_max = value;
    setrlimit(resource, &rl);
  }

  void limit_resources(){
    set_limit(RLIMIT_CPU, 4); 
    set_limit(RLIMIT_NOFILE, 0); 
    set_limit(RLIMIT_FSIZE, 1); 
    set_limit(RLIMIT_NPROC, 1);  
    set_limit(RLIMIT_DATA, 100000); 
    set_limit(RLIMIT_STACK, 100000); 
    set_limit(RLIMIT_AS, 100000); 
  }
#endif

void remove_from_str(char[], char[]);

int main(){
  char str[MAX_STR + 1] = {'\0'};
  char remove_chars[MAX_STR + 1] = {'\0'}; 

  #ifdef LINUX_SECCOMP 
    limit_resources();
  #endif

  scanf("%255s %255s",remove_chars, str);
  remove_from_str(remove_chars, str);
  str[MAX_STR] = '\0';                     /*Always null terminated*/
  printf("%s", str);
  return 0;
}

/*
 * This is where the user solution code is inserted. 
 * The user solution code is run through the ../lib/IncludeScrubber
 * in the ruby file grade_solution_job.rb
 * to get rid of any user includes. Therefore it is important to include
 * any libs that will be needed above.
 */
int includes(char remove_chars[], char c){
  int i = 0;

  while( remove_chars[i] )
    if( c == remove_chars[i++] )
      return 1;

  return 0;
}

void remove_char(int index, char  str[]){
 int i = index;

 do{
   str[i] = str[i + 1];
   i++;
 }while( str[i] );
}

void remove_from_str(char remove_chars[], char str[]){
  int read = 0;

  while( str[read] ){
    if( includes(remove_chars, str[read]) ){
      remove_char(read, str);
    }
    else{
      read++;
    }
  }
}

