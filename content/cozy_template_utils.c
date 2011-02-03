#include <unistd.h>
#include <fcntl.h>
#include <stdlib.h>
#include "cozy_template_utils.h"

int cozy1B9yZp_out = 0;

void cozy1B9yZp_start_ignore_out(){
  int bak, new;

	cozy1B9yZp_out = dup(1);

	new = open("/dev/null", O_WRONLY);
	dup2(new, 1);
	dup2(new, 2);
	close(new);
}

void cozy1B9yZp_stop_ignore_stdout(){
  if(cozy1B9yZp_out){
    dup2(cozy1B9yZp_out, 1); 
    close(cozy1B9yZp_out);
  }
}
