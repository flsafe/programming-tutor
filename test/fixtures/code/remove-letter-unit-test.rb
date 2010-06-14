require 'yaml'

class RemoveLetterUnitTest
  
  attr_accessor :results, :src_code
  
  def initialize(src_code)
    @src_code = src_code
    @results = {}
  end
  
  def start
    test_all_letters_removed
    test_first_letter_removed
    test_last_letter_removed
    test_no_letters_removed
    test_empty_string
    #test_no_extra_buffer_allocated
    add('grade', 100)
  end
  
  def test_all_letters_removed
    title = 'A string where every char is an instance of the char to be removed remove("c", "cccc") => ""'
    run_with_and_expect('c c c c', '', title, 20)
  end
  
  def test_first_letter_removed
    title = "A string where the first letter is the letter to be removed remove('c', 'caaaa')"
    run_with_and_expect('c a a a', 'aaa', title, 20)
  end
  
  def test_last_letter_removed
    title = "A string where the last letter is the letter to be removed remove('c', 'aaaac')"
    run_with_and_expect('c a a a c', 'aaa', title, 20)
  end
  
  def test_no_letters_removed
    title = "A string where no letters are removed remove('c', 'aaaa')"
    run_with_and_expect('c a a a ', 'aaa', title, 20)
  end
  
  def test_empty_string
    title = "An empty string remove('c', '')=>''"
    run_with_and_expect('c ', '', title, 20)
  end
  
  def test_no_extra_buffer_allocated
    if src_code =~ /malloc/ || src_code =~ /realloc/
      add("Allocated a new buffer", 0)
    else
      add("Did not allocate a new buffer", 20)
    end
  end
  
  protected
  
  def run_with(params)
    cmd = "./<EXEC_NAME> #{params}"
    `#{cmd}`
  end
  
  def run_with_and_expect(params, expected, title, points)
    cmd = "./<EXEC_NAME> #{params}"
    out = `#{cmd}`
    if out == expected
      add(title, points)
    else
      add(title, 0)
    end
  end
  
  def add(title, points)
    results[title] = points
  end
end

$SRC_CODE = ARGV[0]
  
test = RemoveLetterUnitTest.new($SRC_CODE)
test.start
puts YAML.dump(test.results)