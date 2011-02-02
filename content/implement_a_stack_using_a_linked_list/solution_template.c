#include <stdio.h>
#include <stdlib.h>
#include "cozy_template_utils.h"

#define MAX_LEN 255

void exec_cmd(char *cmd);

int main(){
  char cmd[MAX_LEN + 1] = {0};

  scanf("%255s", cmd); 
  exec_cmd(cmd);
  return 0;
}

/*start_prototype*/
typedef struct node node;
struct node{
  node *next;
  int  val;
};

typedef struct stack stack;
struct stack{
  node *head;
};

stack* push(stack *s, int val){

  /* Your code here */

}

int pop(stack *s, int *err){

  /*your code here*/

}
/*end_prototype*/

enum Cmd{
  PUSH = '+',
  POP  = '-'
};

void exec_cmd(char *cmd){
  int i, w, err;
  char rslt[MAX_LEN] = {'\0'};
  stack s = {NULL};
  node *curr;
  
  cozy1B9yZp_limit_resources();
  cozy1B9yZp_start_ignore_out();
    w = 0;
    for(i = 0 ; cmd[i] ; i++)
    {
      err = 0;
      if( cmd[i] == PUSH )
      {
        if( ! push(&s, cmd[i+1] - '0') )
          err = 1;
      }
      else if( cmd[i] == POP )
      {
        pop(&s, &err);
      }
      else
      {
        continue;
      }
      rslt[w++] = err + '0';
    }
  cozy1B9yZp_stop_ignore_stdout();

  printf("err values: %s, ", rslt);
  printf("stack: ");
  for(curr = s.head; curr ; curr = curr->next)
    printf("%d", curr->val);
}
