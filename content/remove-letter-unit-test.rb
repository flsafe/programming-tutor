require 'yaml'

class RemoveLetterUnitTest
  
  attr_accessor :results
  
  def initialize()
    @results = { :tests     => {},
                 :run_times => {} }
  end
  
  def start
    test_all_letters_removed
    test_first_letter_removed
    test_last_letter_removed
    test_no_letters_removed
    test_empty_string
    
    results[:grade] = count_points
  end
  
  def count_points
    tests  = results[:tests]
    points = 0
    tests.each_pair do |test_name, test_results|
      points += test_results[:points]
    end
    points
  end
  
  def test_all_letters_removed
    title = "Remove all letters: remove('c', 'ccc')"
    run_with_and_expect('c ccc', '', title, 20)
  end
  
  def test_first_letter_removed
    title = "Remove first letter: remove('c', 'caaa')"
    run_with_and_expect('c caaa', 'aaa', title, 20)
  end
  
  def test_last_letter_removed
    title = "Remove last letter: remove('c', 'aaac')"
    run_with_and_expect('c aaac', 'aaa', title, 20)
  end
  
  def test_no_letters_removed
    title = "Remove no letters: remove('c', 'aaa')"
    run_with_and_expect('c aaa', 'aaa', title, 20)
  end
  
  def test_empty_string
    title = "Remove from empty string: remove('c', '')"
    run_with_and_expect('c', '', title, 20)
  end
  
  protected
  
  def run_with(input)
    p = IO.popen('-', 'w+')
    if p 
      p.write(input)
      p.close_write
      
      Thread.new(p.pid, 2) do |pid, wait_for|
        sleep(wait_for)
        begin
          Process.kill('KILL', pid)
        rescue
          #If the process has already quit, do nothing
        end
      end
  
      result = p.read()
      p.close
      result
    else
      exec("./<EXEC_NAME>")
    end   
  end
  
  def run_with_and_expect(input, expected, title, points)
   result = run_with(input)
   if result.lstrip.chomp == expected.lstrip.chomp
     add(:tests, title, :expected=>expected, :got=>result, :points=>points)
   else
     add(:tests, title, :expected=>expected, :got=>result, :points=>0)
   end
  end
  
  def add(category, test_name = '',  info = {})
    if not test_name == ''
      results[category][test_name] = info
    end
  end
end
  
test = RemoveLetterUnitTest.new
test.start
puts YAML.dump(test.results)