#include <stdio.h>
#include <stdlib.h>

typedef struct node node;
struct node{
  node *next;
  char val;
};

int push(node **head, char c){
  node * new = NULL;

  new = malloc(sizeof(node));
  if (!new)
    return 0;

  new->val = c;
  new->next = *head;

  *head = new;
  return 1;
}

void reverse_print(node *n){
  node * curr = NULL;
  node * stack = NULL;

  for (curr = n ; curr ; curr = curr->next)
    if ( ! push(&stack, curr->val))
      return;

  for (curr = stack ; curr ; curr = curr->next)
    printf("%c", curr->val);
}
