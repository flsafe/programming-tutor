class UnitTest < ActiveRecord::Base
  belongs_to :exercise
  
  validates_presence_of :src_language, :src_code
  
  attr_reader :filled_in_src_code
  
  def run_on(template)
    unless FileUtils.mkdir_p('tmp/work/')
      return {:error=>"Work dir failed"}
    end
    
    file_name = generate_unique_name(template)
    unless template.compile_to("tmp/work/#{file_name}")
      return {:error=>"Could not compile"}
    end
    
    self.fill_in_executable_to_test(file_name)
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
  
  def fill_in_executable_to_test(file_name)
    @filled_in_src_code = src_code.gsub(/<EXEC_NAME>/, file_name)
  end
  
  def generate_unique_name(template)
    "tmp-#{Time.now}-#{template.id}"
  end
  
  def self.language(unit_test_field)
    case UnitTest.base_part_of(unit_test_field.original_filename)
      when /\.(c)$/
        $1
      when /\.(rb)$/
        $1
    end
  end
  
  def self.base_part_of(file_name) 
    File.basename(file_name).gsub(/[^\w._-]/, '') 
  end 
end