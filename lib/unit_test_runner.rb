require 'json'
require 'lib/ideone_client'

#
# Mixin for UnitTest. Executes all functions that
# start with the letters "test" and calculates the final grade.
# Each test method is called in its own thread.
#

module UnitTestRunner 
  
  def start
    call_test_methods()
    calculate_final_grade() 
  end
  
  def run_with_and_expect(input, expected, test_name = nil, points = @points_per_test)
   results = run_with(input)
   output = results[:output]
   if output.strip.chomp == expected.strip.chomp
     points = @points_per_test
   else
     points = 0
   end

   results = {:input=>input, 
              :expected=>expected, 
              :got=>output, 
              :points=>points}.merge(results)
   add_test_result(test_name || create_auto_test_name() , results)
  end
  
  private

  def call_test_methods
    threads = []
    public_methods.each do |message|
      if message =~ /^test/
        threads << Thread.new(message) {|m| send(m)}
      end
    end
    threads.each {|thr| thr.join}
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
      caller_m = callr.match(/`(test_.+)'/)
      return humanize( caller_m[1] ) if caller_m and caller_m[1]
    end
    "Test case"
  end

  def humanize(str)
    str.gsub(/_/,' ').gsub(/test/, "").strip.capitalize
  end

  def run_with(input)
    client = IdeoneClient.new(APP_CONFIG['ideone']['user'], APP_CONFIG['ideone']['password'])
    link = client.run_code(@solution_code, input)
    results = client.get_code_results(link)
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
