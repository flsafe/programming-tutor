#include "cozy_template_utils.h"

void cozy1B9yZp_set_limit(int resource, int value){         
#ifdef LINUX_SECCOMP
  struct rlimit rl;
                
  rl.rlim_cur = value;
  rl.rlim_max = value;
  setrlimit(resource, &rl);
#endif
}

void cozy1B9yZp_limit_resources(){
#ifdef LINUX_SECCOMP
  cozy1B9yZp_set_limit(RLIMIT_CPU, 4); 
  cozy1B9yZp_set_limit(RLIMIT_NOFILE, 0); 
  cozy1B9yZp_set_limit(RLIMIT_FSIZE, 1); 
  cozy1B9yZp_set_limit(RLIMIT_NPROC, 1);  
  cozy1B9yZp_set_limit(RLIMIT_DATA, 100000); 
  cozy1B9yZp_set_limit(RLIMIT_STACK, 100000); 
  cozy1B9yZp_set_limit(RLIMIT_AS, 100000); 
#endif
}

void cozy1B9yZp_start_ignore_out(){
#ifdef LINUX_SECCOMP
  /*TODO: This is Non-standard*/
  cozy1B9yZp_out = stdout;
  stdout = fopen("/dev/null", "w");  
  stderr = fopen("/dev/null", "w");
#endif
}

void cozy1B9yZp_stop_ignore_stdout(){
#ifdef LINUX_SECCOMP
  if(cozy1B9yZp_out){
    stdout = cozy1B9yZp_out;
  }
#endif
}
