#include<string.h>
#include<strings.h>
#include<stdlib.h>

/*
 * Allocate a buffer to copy str into. Caller
 * frees memory.
 */
char* allocate_tmp_buffer(char str[]){
  unsigned int len = 0;
  char *tmp_buffer = NULL;

  if(! str )
    return NULL;

  len = strlen(str) + 1; 
  tmp_buffer = (char*) malloc( len * sizeof(char)); 
  if( ! tmp_buffer )
    return NULL;
  bzero(tmp_buffer, len * sizeof(char));

  return tmp_buffer;
}

/*
 * An algorithm to remove characters from str. 
 * Assumes ASCII
 */
void remove_from_str(char remove_chars[], char str[]){
  int  read = 0, write = 0, i = 0;
  char removetab[128] = {'\0'}, *tmp_buffer = NULL, c = 0;

  if( ! (remove_chars && str) )
    return;

  tmp_buffer = allocate_tmp_buffer(str);
  if( ! tmp_buffer )
    return;
  
  for(i = 0 ; remove_chars[i] ; i++)
    removetab[ remove_chars[i] ] = 1;

  do{
    c = str[read];
    if( ! removetab[ c ] )
      tmp_buffer[write++] = c;
    read++;
  }while( c );
  strcpy(str, tmp_buffer);

  free(tmp_buffer);
}
