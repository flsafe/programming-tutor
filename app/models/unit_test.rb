require 'yaml'

class UnitTest < ActiveRecord::Base
  belongs_to :exercise
  
  validates_presence_of :src_language, :src_code
  
  named_scope :written_in, lambda {|lang| {:conditions=>{:src_language=>lang}}}
  
  named_scope :for_exercise, lambda {|exercise_id| {:conditions=>{:exercise_id=>exercise_id}}}
  
  def run_on(solution_code = nil)
    begin
      initialize_unit_test_working_paths
      substitute_executable_path_in_unit_test_code
      
      successfuly_compiled = Compiler.compile_to(solution_code, @exec_file_path)
      return {:error=>"The solution code did not compile"} unless successfuly_compiled

      write_unit_test_to_file
      results_hash = execute_unit_test_file
      if error_results?(results_hash)
        return {:error=>"The solution template did not return a YAML result"}
      end
      
      results_hash.with_indifferent_access
    rescue Exception => e
      return {:error=>"Unexpected exception: #{e.message}"}
    end
  end
  
  def unit_test_file=(unit_test_file)
    self.attributes = UnitTest.from_file_field(unit_test_file)
  end
  
  def self.from_file_field(unit_test_field)
    return unless unit_test_field
    src_language = UnitTest.language(unit_test_field)
    src_code     = unit_test_field.read
    
    {:src_language=>src_language, :src_code=>src_code}
  end
  
  protected
  
  
  def initialize_unit_test_working_paths
    @exec_file_path = CozyFileUtils.unique_file_in(work_dir, 'tmp')
    @unit_test_path = @exec_file_path + '-unit-test'      
  end
  
  def substitute_executable_path_in_unit_test_code
    @unit_test_src_code = src_code.gsub(/<EXEC_NAME>/, @exec_file_path)
  end

  def execute_unit_test_file
    result_yaml = `ruby #{@unit_test_path}`
    YAML.load(result_yaml || "")
  end
  
  def write_unit_test_to_file
    f = File.open(@unit_test_path, 'w')
    f.write(@unit_test_src_code)
    f.close
  end
  
  def error_results?(results)
    not valid_results?(results)
  end
  
  def valid_results?(results)
    results && ( not results[:grade].blank?) && ( not results[:tests].blank?)
  end
  
   def work_dir
    APP_CONFIG['work_dir']
  end
  
  def self.language(unit_test_field)
    case UnitTest.base_part_of(unit_test_field.original_filename)
      when /\.(c)$/
        $1
      when /\.(rb)$/
        $1
    end
  end
  
  def self.base_part_of(user_program) 
    File.basename(user_program).gsub(/[^\w._-]/, '') 
  end 
end