
def test_empty_string
  run_with_and_expect('', '')
end

def test_small_string 
  run_with_and_expect('a', 'a')
end

def test_even_string
  run_with_and_expect('abcd', 'dcba')
end

def test_odd_string 
  run_with_and_expect('xyz', 'zyx')
end

def test_long_string
  run_with_and_expect("0123456789", "9876543210")
end
