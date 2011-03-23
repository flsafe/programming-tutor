
/*start_prototype*/
#include <stdio.h>
#include <stdlib.h>

typedef struct node node;
struct node{
  node *next;
  char val;
};

void reverse_print(node *n){

  /* your code here*/

}
/*end_prototype*/

#define MAX_LEN 255

void append(node** n, char c){
  node *new_node, *last;

  new_node = malloc(sizeof(node));
  new_node->next = NULL;
  new_node->val = c;

  if (! *n){
    *n = new_node;
  }
  else {
   for (last = *n ; last->next ; last = last->next)
     ; /* move to last node */
   last->next = new_node; 
  }
}

node* to_linked_list(char input[]){
  node *list = NULL; 
  int i = 0;

  for (i = 0 ; input[i] ; i++)
    append(&list, input[i]);

  return list;
}

int main(){
  node *head = NULL;
  char input[MAX_LEN + 1] = {0};

  scanf("%255s", input); 
  head = to_linked_list(input);
  reverse_print(head);
   
  return 0;
}
