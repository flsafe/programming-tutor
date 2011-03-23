#include <stdio.h>
#include <stdlib.h>

typedef struct node node;
struct node{
  node *next;
  char val;
};

void reverse_print(node *n){
  node *curr = NULL;
  char *buff = NULL;
  int i = 0, count = 0;

  count = 0;
  for (curr = n ; curr ; curr = curr->next)
    count++;

  buff = malloc(sizeof(char) * count + 1);
  if (!buff) 
    return;
  buff[count] = '\0';

  i = count - 1;
  for (curr = n ; curr ; curr = curr->next)
    buff[i--] = curr->val;

  printf("%s", buff);
}
