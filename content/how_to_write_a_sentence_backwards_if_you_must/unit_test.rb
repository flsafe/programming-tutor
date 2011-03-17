
def test_reverse_even_length_string
  run_with_and_expect('abcdef', 'fedcba')
end

def test_reverse_odd_length_string 
  run_with_and_expect('123456789', '987654321')
end

def test_reverse_empty_string
  run_with_and_expect('', '')
end

def test_reverse_string_with_length_one 
  run_with_and_expect('a', 'a')
end
