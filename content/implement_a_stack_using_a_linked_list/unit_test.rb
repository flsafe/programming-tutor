
def test_push_one_element 
  run_with_and_expect('+1', exp("0 1"))
end

def test_pop_empty_stack
  run_with_and_expect('-', exp("1"))
end

def test_pop_and_push_one_element
  run_with_and_expect('+1-', exp('00'))
end

def test_push_multiple 
  run_with_and_expect('+1+2+3+4', exp('0000 4321'))
end

def exp(str)
  err_values = str.split[0] || ""
  stack = str.split[1] || ""
  "err values: %s, stack: %s" % [err_values, stack] 
end
