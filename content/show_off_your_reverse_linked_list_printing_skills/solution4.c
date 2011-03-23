typedef struct node node;
struct node{
  node *next;
  char val;
};

void reverse_print(node *n){
  node *curr = NULL, *stop = NULL;

  while (stop != n){
    for (curr = n ; curr->next != stop ; curr = curr->next)
      ; /* Move curr forward */
    stop = curr;

    printf("%c", curr->val);
  }
}
