#include "cozy_template_utils.h"
#include <stdio.h>
#include <sys/time.h>
#include <sys/resource.h>

FILE* cozy1B9yZp_out = NULL;

void cozy1B9yZp_set_limit(int resource, int value){         
  struct rlimit rl;
                
  rl.rlim_cur = value;
  rl.rlim_max = value;
  setrlimit(resource, &rl);
}

void cozy1B9yZp_limit_resources(){
  cozy1B9yZp_set_limit(RLIMIT_CPU, 4); 
  cozy1B9yZp_set_limit(RLIMIT_NOFILE, 0); 
  cozy1B9yZp_set_limit(RLIMIT_FSIZE, 1); 
  cozy1B9yZp_set_limit(RLIMIT_NPROC, 1);  
  cozy1B9yZp_set_limit(RLIMIT_DATA, 100000); 
  cozy1B9yZp_set_limit(RLIMIT_STACK, 100000); 
  cozy1B9yZp_set_limit(RLIMIT_AS, 100000); 
}

void cozy1B9yZp_start_ignore_out(){
  /*TODO: This is Non-standard*/
  cozy1B9yZp_out = stdout;
  stdout = fopen("/dev/null", "w");  
  stderr = fopen("/dev/null", "w");
}

void cozy1B9yZp_stop_ignore_stdout(){
  if(cozy1B9yZp_out){
    stdout = cozy1B9yZp_out;
  }
}
