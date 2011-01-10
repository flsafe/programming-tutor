void remove_from_str(char remove_chars[], char str[]){
  int read = 0, write = 0, i = 0;
  char c = 0;
  char remove[256] = {'\0'};

  while( remove_chars[i] ){
    remove[ remove_chars[i++] ] = 1;
  }

  do{
    c = str[read];
    if( !remove[c] ){
      str[write++] = str[read];
    }
    read++;
  }while(c);
}

