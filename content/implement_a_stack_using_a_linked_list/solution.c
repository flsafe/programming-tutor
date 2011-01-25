#include <stdlib.h>

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
  /*your code here*/
  node * newelem;

  if( ! s )
    return NULL;

  newelem = (node*) malloc(sizeof(node));
  if( ! newelem )
    return NULL;

  newelem->next = s->head;
  newelem->val = val;
  s->head = newelem;

  return s;
}

int pop(stack *s, int *err){
  /*your code here*/
  int val;
  node *elem;

  if( ! s->head ){
    *err = 1;
    return 0;
  }

  elem = s->head;
  s->head = elem->next;
  val = elem->val;
  free(elem);
  *err = 0;

  return val;
}
/*end prototype*/
