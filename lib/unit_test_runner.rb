require 'yaml'

module UnitTestRunner 
  
  def start
    call_test_methods()
    calculate_final_grade() 
  end
  
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
    public_methods.each do |m|
      send(m) if m =~ /^test/
    end
  end

  def calculate_final_grade 
    tests  = @results[:tests]
    points = 0
    tests.each_pair do |test_name, test_results|
      points += test_results[:points]
    end
    @results[:grade] = clamp(points.round)
  end

  def create_auto_test_name
    Kernel.caller.each do | callr |
      caller_m = /`(test_.+)'/.match(callr)
      return humanize( caller_m[1] ) if caller_m and caller_m[1]
    end
    "Test case"
  end

  def humanize(str)
    str.gsub(/_/,' ').gsub(/test/, "").strip.capitalize
  end

  def run_with(input)
    # Execute @testcode with input
    ""
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
