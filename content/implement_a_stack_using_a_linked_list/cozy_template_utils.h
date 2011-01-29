#include <stdio.h>
#ifdef LINUX_SECCOMP 
  #include <sys/time.h>
  #include <sys/resource.h>
#endif

FILE* cozy1B9yZp_out = NULL;

void cozy1B9yZp_set_limit(int resource, int value);

void cozy1B9yZp_limit_resources();

void cozy1B9yZp_start_ignore_out();

void cozy1B9yZp_stop_ignore_stdout();
