void remove_from_str(char remove_chars[], char str[]){
  int  read = 0, write = 0, i = 0;
  char removetab[128] = {'\0'}, c = 0;

  if( ! (remove_chars && str) )
    return;

  for(i = 0 ; remove_chars[i] ; i++){
    removetab[ remove_chars[i] ] = 1;
  }

  do{
    c = str[read];
    if( ! removetab[c] ){
      str[write++] = str[read];
    }
    read++;
  }while(c);
}

