Given /^I have finished "([^\"]*)" with a "([^\"]*)"$/ do |title, grade|
  ta = TeachersAid.new
  exercise = Exercise.find_by_title title
  ta.record_grade(Factory.build :grade_sheet, :user=>@current_user, :exercise=>exercise, :grade=>grade)
end

Given /^"([^\"]*)" has the grades "([^\"]*)"$/ do |exercise_title, grades|
  exercise = Exercise.find_by_title exercise_title
  ta = TeachersAid.new
  grades   = grades.split.collect {|g| g.to_f}
  0.upto(grades.count - 1) do |n|
    ta.record_grade(Factory.create :grade_sheet, :exercise=>exercise, :grade=>grades[n])
  end
end

Given /^the exercise "([^\"]*)" has the associated solution template and unit test$/ do |exercise_title|
  template = <<END
#include <stdlib.h>
#include <stdio.h>

void remove_char(char, char[]);
void do_remove_char(char, char[]);

int main(int argc, char* argv[]){
  char *str;
  char remove;
  int str_size;
  
  int write, read;
	
	if(argc < 2){
		printf("Not enough arguments\n");
		return 1;
	}

  remove   = *argv[1];
  str_size = argc - 2;

  str      = malloc(sizeof(char) * str_size + 1);
	for(write = 0, read = 2 ; write < str_size; write++, read++)
    str[write] = *argv[read];
	str[write] = 0;

  remove_char(remove, str);
  printf("%s", str);
  
  return 0;
}

void remove_char(char c, char str[]){
  <SRC_CODE>
}
END

  unit_test = <<END
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
    test_no_extra_buffer_allocated
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
    cmd = "./remove \#{params}"
    `\#{cmd}`
  end
  
  def run_with_and_expect(params, expected, title, points)
    cmd = "./remove \#{params}"
    out = `\#{cmd}`
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
END
  exercise = Exercise.find_by_title exercise_title
  exercise.solution_templates.create :src_code=>template
  exercise.unit_tests.create :src_code=>unit_test
end

When /^I view exercise "([^\"]*)"$/ do |title|
  exercise = Exercise.find_by_title title
  visit exercise_path(exercise)
end

Then /^I should see exercise "([^\"]*)" with "([^\"]*)"$/ do |title, text|
  page.should have_css ".exercise", :content=>title do |exercise_set|
    exercise_set.should contain text
  end
end