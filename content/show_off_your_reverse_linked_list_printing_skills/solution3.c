#include <stdio.h>
#include <stdlib.h>

typedef struct node node;
struct node{
  node *next;
  char val;
};

void reverse_print(node *n){
  if (n){
    reverse_print(n->next);
    printf("%c", n->val);
  }
}
