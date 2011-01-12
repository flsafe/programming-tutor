require 'yaml'

class RemoveLetterUnitTest
  
  attr_accessor :results
  
  def initialize()
    @results = { :tests     => {},
                 :run_times => {} }
  end
  
  def start
    @points_per_test = 100.0 / self.public_methods.count {|m| m =~ /^test/}

    self.public_methods.each do |m|
      self.send(m) if m =~ /^test/
    end
    
    results[:grade] = count_points
  end
  
  
  def test_all_letters_removed
    title = 'Remove all letters: remove_from_str("c", "ccc")'
    run_with_and_expect('c ccc', '', title, @points_per_test)
  end
  
  def test_first_letter_removed
    title = 'Remove first letter: remove_from_str("c", "caaa")'
    run_with_and_expect('c caaa', 'aaa', title, @points_per_test)
  end
  
  def test_last_letter_removed
    title = 'Remove last letter: remove_from_str("c", "aaac")'
    run_with_and_expect('c aaac', 'aaa', title, @points_per_test)
  end
  
  def test_no_letters_removed
    title = 'Remove no letters: remove_from_str("c", "aaa")'
    run_with_and_expect('c aaa', 'aaa', title, @points_per_test)
  end
  
  def test_empty_string
    title = 'Remove from empty string: remove_from_str("c", "")'
    run_with_and_expect('c', '', title, @points_per_test)
  end

  def test_multiple_remove_letters_from_middle
    title = 'Remove multiple chars: remove_from_str("abc", "czbzaz")'
    run_with_and_expect("abc czbzaz", "zzz", title, @points_per_test)
  end

  def test_multiple_remove_all_letters
    title = 'Remove multiple chars: remove_from_str("xkcd", "xkcd")'
    run_with_and_expect("xkcd xkcd", "", title, @points_per_test)
  end

  def test_multiple_remove_all_at_end
    title = 'Remove multiple chars: remove_from_str("xyz", "abcxyz")'
    run_with_and_expect("xyz abcxyz", "abc", title, @points_per_test)
  end

  def test_multiple_remove_all_at_front
    title = 'Remove multiple chars: remove_from_str("xyz", "xyzabc")'
    run_with_and_expect("xyz xyzabc", "abc", title, @points_per_test)
  end

  def test_multiple_remove_all_at_middle
    title = 'Remove multiple chars: remove_from_str("xyz", "abcxyzabc")'
    run_with_and_expect("xyz abcxyzabc", "abcabc", title, @points_per_test)
  end

  protected

  def run_with_and_expect(input, expected, title, points)
   result = run_with(input)
   if result.strip.chomp == expected.strip.chomp
     add(:tests, title, :expected=>expected, :got=>result, :points=>points)
   else
     add(:tests, title, :expected=>expected, :got=>result, :points=>0)
   end
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
  
test = RemoveLetterUnitTest.new
test.start
puts YAML.dump(test.results)
