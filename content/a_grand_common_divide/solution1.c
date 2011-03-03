unsigned int gcd(unsigned int a, unsigned int b){
  unsigned int i;

  i = a < b ? a : b;
  
  for (; i ; i--)
    if (a % i == 0 && b % i == 0)
      return i;

  return 1;
}
