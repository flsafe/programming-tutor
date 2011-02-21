#include <stdio.h>
#include <stdlib.h>

#define MAX_LEN 255

void exec_cmd(char *cmd);

int main(){
  char cmd[MAX_LEN + 1] = {0};

  scanf("%255s", cmd); 
  exec_cmd(cmd);
  return 0;
}

/*start_prototype*/
#include <stdlib.h>

typedef struct stack stack;
struct stack{
  stack *next;
  int  val;
};

int push(stack **s, int val){
  /* Your code here */
}

int pop(stack **s, int *val){
  /* Your code here */
}
/*end_prototype*/

enum Cmd{
  PUSH = '+',
  POP  = '-'
};

void exec_cmd(char *cmd){
  int i, w, data, err;
  char rslt[MAX_LEN] = {0};
  stack *s = NULL, *curr = NULL;
  
  w = 0;
  for(i = 0 ; cmd[i] ; i++)
  {
    err = 0;
    if( cmd[i] == PUSH )
    {
       err = push(&s, cmd[i+1] - '0');
    }
    else if( cmd[i] == POP )
    {
      err = pop(&s, &data);
    }
    else
    {
      continue;
    }
    rslt[w++] = err + '0';
  }

  printf("err values: %s, ", rslt);
  printf("stack: ");
  for(curr = s; curr ; curr = curr->next)
    printf("%d", curr->val);
}
