unsigned int gcd(unsigned int a, unsigned int b){
  int tmp;

  while (b){
    tmp = b;
    b = a % b;
    a = tmp;
  }

  return a;
}
