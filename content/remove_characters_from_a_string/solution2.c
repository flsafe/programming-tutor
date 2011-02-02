#include<string.h> 

/*
 * Return 1 if remove_chars includes c 
 */
int includes(char remove_chars[], char c){
  int i = 0;

  if( ! remove_chars )
    return 0;

  for(i = 0 ; remove_chars[i] ; i++)
    if( c == remove_chars[i] )
      return 1;

  return 0;
}

/*
 * Remove the character at index from str
 * by left shifting str.
 */
void remove_char(int index, char  str[]){
 int i;

 if( (! str) || index < 0 || index >= strlen(str) )
   return;

 for(i = index ; str[i] ; i++)
   str[i] = str[i + 1];
}


/*
 * A naive algorithm to remove all characters in
 * remove_chars from str.
 */
void remove_from_str(char remove_chars[], char str[]){
  int read = 0;

  if( ! (remove_chars && str) )
    return;

  while( str[read] ){
    if( includes(remove_chars, str[read]) )
      remove_char(read, str);
    else
      read++;
  }
}

