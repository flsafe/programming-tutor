def test_remove_all_characters
  run_with_and_expect('c ccc')
end

def test_remove_first_character
  run_with_and_expect('c caaa', 'aaa')
end

def test_remove_last_character
  run_with_and_expect('c aaac', 'aaa') 
end

def test_no_characters_removed
  run_with_and_expect('c aaa', 'aaa')
end

def test_empty_string
  run_with_and_expect('c', '') 
end

def test_remove_characters_from_middle
  run_with_and_expect("abc czbzaz", "zzz")
end

def test_remove_all_characters
  run_with_and_expect("xkcd xkcd", "")
end

def test_remove_characters_from_end
  run_with_and_expect("xyz abcxyz", "abc")
end

def test_remove_characters_from_front
  run_with_and_expect("xyz xyzabc", "abc") 
end

def test_remove_characters_from_middle
  run_with_and_expect("xyz abcxyzabc", "abcabc")
end
