
def test_all_letters_removed
  run_with_and_expect('c ccc', '')
end

def test_first_letter_removed
  run_with_and_expect('c caaa', 'aaa')
end

def test_last_letter_removed
  run_with_and_expect('c aaac', 'aaa') 
end

def test_no_letters_removed
  run_with_and_expect('c aaa', 'aaa')
end

def test_empty_string
  run_with_and_expect('c', '')
end
