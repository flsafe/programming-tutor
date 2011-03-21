require 'yaml'
require 'lib/unit_test_runner'

class UnitTest < ActiveRecord::Base
  belongs_to :exercise
  
  validates_presence_of :src_language, :src_code
  
  named_scope :written_in, lambda {|lang| {:conditions=>{:src_language=>lang}}}
  
  named_scope :for_exercise, lambda {|exercise_id| {:conditions=>{:exercise_id=>exercise_id}}}

  include UnitTestRunner

  def unit_test_file=(unit_test_file)
    attributes = from_file_field(unit_test_file)
  end

  def run_on(solution_code = nil)
    begin
      init(solution_code)
      start
      @results.with_indifferent_access
    rescue Exception => e
      Rails.logger.error "A unit test threw an exception: #{e.message} #{e.backtrace}"
      return {:error=>"#{e.message}"}
    end
  end

  def check_on(solution_code = nil)
    begin
      init(solution_code)
      start
      feedback(@results.with_indifferent_access)
    rescue Exception => e
      e.message
    end
  end
  
  protected

  def init(solution_code)
    @solution_code = solution_code
    @results = { :grade     => 0,
                 :tests     => {},
                 :run_times => {} }

    class_eval(src_code)
    @points_per_test = 100.0 / public_methods.count {|m| m =~ /^test/}
  end
  
  def error_results?(results)
    not valid_results?(results)
  end
  
  def valid_results?(results)
    results && (not results[:grade].blank?) && (not results[:tests].blank?)
  end

  def feedback(results)
    error_feedback = give_runtime_error_feedback(results)
    if error_feedback
      return error_feedback
    else
      return correctness_feedback(results)
    end
  end

  def give_runtime_error_feedback(results)
    results[:tests].each_pair do |test_name, test_result|
      if test_result[:runtime_error?]
        return "Are you sure this wouldn't crash at runtime?"
      elsif test_result[:timeout_error?]
        return "I think this would go into an infinite loop"
      elsif test_result[:memory_error?]
        return "Don't you think this might run out of memory?"
      elsif test_result[:syscall_error]
        return "You don't really need to make that system call"
      end
    end
    nil
  end

  def correctness_feedback(results)
    results[:tests].each_pair do |test_name, test_result|
      if test_result[:got].strip.chomp != test_result[:expected].strip.chomp
        unless test_result[:input].empty?
          return "Are you sure this works for this input?: #{test_result[:input]}"
        else
          return "I'm not sure this is correct. It may have a bug"
        end
      end
    end
    "This looks like it could work!"
  end
  
  def from_file_field(unit_test_field)
    return unless unit_test_field
    src_language = CozyFileUtils.language(unit_test_field.original_filename)
    src_code     = unit_test_field.read
    
    {:src_language=>src_language, :src_code=>src_code}
  end
end
