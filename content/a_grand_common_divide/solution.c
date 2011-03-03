unsigned int gcd(unsigned int a, unsigned int b){
  unsigned int mod;

  while (b){
    mod = a % b;
    a = b;
    b = mod;
  }
  return a;
}
