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
      
      result = p.read()
      p.close
      result
    else
      set_child_limits
      exec("sandbox ./<EXEC_NAME>")
    end   
  end

  def set_child_limits
    # Note: The current user will already have
    # procs running, files open, and other resources
    # in use. Therefore these limits need to be set high enough
    # to account for the resources already in use and to limit 
    # any new resources the user submited solution will consume.
    #
    # TODO: When in production mode NProcs should be smaller
    max_mem = 1048576
    max_cpu_secs = 4
    max_files = 20
    max_file_size = 1
    max_procs = 50

    Process.setrlimit(Process::RLIMIT_CPU, max_cpu_secs)

    Process.setrlimit(Process::RLIMIT_NOFILE, max_files)
    
    Process.setrlimit(Process::RLIMIT_FSIZE, max_file_size)

    Process.setrlimit(Process::RLIMIT_NPROC, max_procs)

    Process.setrlimit(Process::RLIMIT_DATA, max_mem)

    Process.setrlimit(Process::RLIMIT_STACK, max_mem)

    Process.setrlimit(Process::RLIMIT_RSS, max_mem)

    Process.setrlimit(Process::RLIMIT_AS, max_mem)
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
