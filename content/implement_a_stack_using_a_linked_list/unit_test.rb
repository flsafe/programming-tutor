
def test_push_one_element 
  run_with_and_expect('+1', exp("1 1"))
end

def test_pop_empty_stack
  run_with_and_expect('---', exp("000"))
end

def test_push_and_pop_one_element
  run_with_and_expect('+1-', exp('11'))
end

def test_push_multiple 
  run_with_and_expect('+1+2+3+4', exp('1111 4321'))
end

def test_push_and_pop_multiple
  run_with_and_expect('+1+2+3+4----', exp('11111111 '))
end

def exp(str)
  err_values = str.split[0] || ""
  stack = str.split[1] || ""
  "err values: %s, stack: %s" % [err_values, stack] 
end
