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
  
  def from_file_field(unit_test_field)
    return unless unit_test_field
    src_language = CozyFileUtils.language(unit_test_field.original_filename)
    src_code     = unit_test_field.read
    
    {:src_language=>src_language, :src_code=>src_code}
  end
end
