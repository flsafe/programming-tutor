#include <stdlib.h>

typedef struct stack stack;
struct stack{
  stack *next;
  int  val;
};

int push(stack **s, int val){
  stack* newelem = malloc(sizeof(stack));
  if(! newelem)
    return 0;
  
  newelem->val = val;
  newelem->next = *s;
  *s = newelem;
  return 1;
}

int pop(stack **s, int *val){
  stack* top;
  if(! *s)
    return 0;

  top = *s;
  *val = top->val;
  *s = top->next;
  free(top);

  return 1;
}
