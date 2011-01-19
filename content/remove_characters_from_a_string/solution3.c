#include<string.h>
#include<strings.h>
#include<stdlib.h>

/*
 * Allocate a buffer to copy str into. Caller
 * frees memory.
 */
char* allocate_cpy_buffer(char str[]){
  unsigned int len = 0;
  char *cpy_buffer = NULL;

  if(! str )
    return;

  len = strlen(str) + 1; 
  cpy_buffer = (char*) malloc( len * sizeof(char)); 
  if( ! cpy_buffer )
    return NULL;
  bzero(cpy_buffer, len * sizeof(char));

  return cpy_buffer;
}

/*
 * Set removetab[c] = 1 for all chars c in remove_chars[]
 */
void set_removetab(char removetab[], char remove_chars[]){
  int i;

  if( ! ( removetab && remove_chars) )
    return;

  for(i = 0; remove_chars[i] ; i++)
    removetab[ remove_chars[i] ] = 1;
}

/*
 * An algorithm to remove characters from str. 
 * Assumes ASCII
 */
void remove_from_str(char remove_chars[], char str[]){
  int  read = 0, write = 0, i = 0;
  char removetab[128] = {'\0'}, *cpy_buffer = NULL, c = 0;

  if( ! (remove_chars && str) )
    return;

  cpy_buffer = allocate_cpy_buffer(str);
  if( ! cpy_buffer )
    return;
  set_removetab(removetab, remove_chars);

  do{
    c = str[read];
    if( ! removetab[ c ] )
      cpy_buffer[write++] = c;
    read++;
  }while( c );
  strcpy(str, cpy_buffer);

  free(cpy_buffer);
}
