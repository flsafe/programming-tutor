def test_zero
  run_with_and_expect('0 0', '0')
end

def test_zero_one_argument
  run_with_and_expect('1 0', '1')
end

def test_zero_other_argument
  run_with_and_expect('0 1', '1')
end

def test_one
  run_with_and_expect('1 1', '1')
end

def test_no_gcd
  run_with_and_expect('3332 5', '1')
end

def test_small
  run_with_and_expect('18 12', '6')
end

def test_large
  run_with_and_expect('394272084 234123412', '4')
end
