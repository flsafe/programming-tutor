require 'yaml'

class UnitTest < ActiveRecord::Base
  belongs_to :exercise
  
  validates_presence_of :src_language, :src_code
  
  def run_on(template, template_id = nil, solution_code = nil)
    work_dir          = APP_CONFIG['work_dir']
    user_program_path = CozyFileUtils.unique_file_in(work_dir, 'tmp')
    unit_test_path    = user_program_path + '-unit-test'
    
    unless Compiler.compile_to(solution_code, user_program_path)
      return {:error=>"Could not compile the solution!"}
    end
    
    unit_test_src_code = src_code.gsub(/<EXEC_NAME>/, user_program_path)
    unless write_unit_test(unit_test_src_code, unit_test_path)
      return {:error=>"A server error occured! Could not prepare the unit test."}
    end

    results = execute_file(unit_test_path)
    
    results_hash = YAML.load(results)
    results_hash = results_hash.with_indifferent_access
    
    unless results_hash and results_hash['grade']
      return {'error'=>"A server error occured! Unit test did not return a grade"}
    end
    results_hash
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

  def execute_file(file)
    `ruby #{file}`
  end
  
  def write_unit_test(src_code, path)
    begin
      f = File.open(path, 'w')
      f.write(src_code)
      f.close
      true
    rescue
      false
    end
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