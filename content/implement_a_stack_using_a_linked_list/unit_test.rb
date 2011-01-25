require 'yaml'

class UnitTest 
  
  attr_accessor :results
  
  def initialize()
    @results = { :tests     => {},
                 :run_times => {} }
    @expect = "err values: %s, stack: %s"
  end
  
  def start
    @points_per_test = 100.0 / self.public_methods.count {|m| m =~ /^test/}

    self.public_methods.each do |m|
      self.send(m) if m =~ /^test/
    end
    
    results[:grade] = count_points
  end

  def exp(str)
    err_values = str.split[0] || ""
    stack = str.split[1] || ""
    @expect % [err_values, stack]
  end
  
  def test1
    title = 'Push one element'
    run_with_and_expect('+1', exp("0 1"), title)
  end
  
  def test2
    title = 'Pop empty stack'
    run_with_and_expect('-', exp("1"), title)
  end
  
  def test3
    title = 'Push and pop one element'
    run_with_and_expect('+1-', exp('00'), title)
  end
  
  def test4
    title = 'Push multiple'
    run_with_and_expect('+1+2+3+4', exp('0000 4321'), title)
  end
  
  protected

  def run_with_and_expect(input, expected, title, points = @points_per_test)
   result = run_with(input)
   if result.strip.chomp == expected.strip.chomp
     add(:tests, title, :input=>input, :expected=>expected, :got=>result, :points=>points)
   else
     add(:tests, title, :input=>input, :expected=>expected, :got=>result, :points=>0)
   end
  end
  
  def run_with(input)
    p = IO.popen('-', 'w+')
    if p 
      p.write(input)
      p.close_write
      
      result = p.read()
      p.close
      puts result
      result
    else
      exec("sandbox ./<EXEC_NAME>")
    end   
  end

  def add(category, test_name = '',  info = {})
    if not test_name == ''
      results[category][test_name] = info
    end
  end

  def count_points
    tests  = results[:tests]
    points = 0
    tests.each_pair do |test_name, test_results|
      points += test_results[:points]
    end
    [[points.round, 100.0].min, 0].max
  end
end
  
test = UnitTest.new
test.start
puts YAML.dump(test.results)
