unsigned int gcd(unsigned int a, unsigned int b){
  unsigned int i;

  if (a == 0 && b == 0)
    return 0;
  else if (a == 0)
    return b;
  else if (b == 0)
    return a;

  i = a < b ? a : b;
  
  for (; ! i <= 1 ; i--)
    if (a % i == 0 && b % i == 0)
      return i;

  return i;
}
