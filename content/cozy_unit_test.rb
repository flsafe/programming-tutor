require 'yaml'

class CozyUnitTest 
  
  attr_reader :results

  @@TEST_REGEX = /`(test_.+)'/

  @@IS_TEST_METHOD = /^test/
  
  def initialize(executable_name)
    @executable_name = executable_name
    @results = { :grade     => 0,
                 :tests     => {},
                 :run_times => {} }
    @points_per_test = 100.0 / self.public_methods.count {|m| m =~ /^test/}
  end

  public 
  
  def start
    call_test_methods()
    calculate_final_grade() 
  end
  
  protected

  def run_with_and_expect(input, expected, test_name = nil, points = @points_per_test)
   test_name = create_auto_test_name() unless test_name
   result = run_with(input)
   if result.strip.chomp == expected.strip.chomp
     add_test_result(test_name, :input=>input, :expected=>expected, :got=>result, :points=>points)
   else
     add_test_result(test_name, :input=>input, :expected=>expected, :got=>result, :points=>0)
   end
  end
  
  private

  def call_test_methods
    self.public_methods.each do |m|
      self.send(m) if m =~ @@IS_TEST_METHOD
    end
  end

  def calculate_final_grade 
    tests  = results[:tests]
    points = 0
    tests.each_pair do |test_name, test_results|
      points += test_results[:points]
    end
    @results[:grade] = clamp(points.round)
  end

  def create_auto_test_name
    Kernel.caller.each do | file_line_in |
      m = @@TEST_REGEX.match(file_line_in)
      return humanize( m[1] ) if m and m[1]
    end
    "Test case"
  end

  def humanize(str)
    str.gsub(/_/,' ').gsub(/test/, "").strip.capitalize
  end

  def run_with(input)
    p = IO.popen('-', 'w+')
    if p 
      p.write(input)
      p.close_write
      
      result = p.read()
      p.close
      result
    else
      exec("sandbox ./#{@executable_name}")
    end   
  end

  def add_test_result(test_name,  info)
      @results[:tests][test_name] = info
  end

  def clamp(v)
    if v > 100
      v = 100
    elsif v < 0
      v = 0
    end
    v
  end
end
