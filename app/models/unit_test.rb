require 'yaml'

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
      return {:error=>"#{e.message} #{e.backtrace}"}
    end
  end
  
  protected

  def init(solution_code)
    @solution_code = solution_code
    @results = { :grade     => 0,
                 :tests     => {},
                 :run_times => {} }
    @points_per_test = 100.0 / public_methods.count {|m| m =~ /^test/}
    class_eval(src_code)
  end
  
  def error_results?(results)
    not valid_results?(results)
  end
  
  def valid_results?(results)
    results && ( not results[:grade].blank?) && ( not results[:tests].blank?)
  end
  
  def from_file_field(unit_test_field)
    return unless unit_test_field
    src_language = CozyFileUtils.language(unit_test_field.original_filename)
    src_code     = unit_test_field.read
    
    {:src_language=>src_language, :src_code=>src_code}
  end
end
