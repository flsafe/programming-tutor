class SolutionTemplate < ActiveRecord::Base
  belongs_to :exercise
  
  validates_presence_of :src_language, :src_code
  
  attr_reader :filled_in_src_code
  
  def compile_to(path)
    Compiler.compile_to(filled_in_src_code, path)
  end
  
  def fill_in(solution_code)
    @filled_in_src_code = src_code.sub(/<SRC_CODE>/, solution_code)
  end
  
  def syntax_error?
    check_code  = filled_in_src_code || "Template not filled in, syntax error"
    msg = Compiler.syntax_error?(check_code)
    msg =~ /error/i ? true : false
  end
  
   def solution_template_file=(template_file)
    self.attributes = SolutionTemplate.from_file_field(template_file)
  end
  
  def self.from_file_field(template_field)
    return unless template_field
    src_language = SolutionTemplate.language(template_field)
    src_code     = template_field.read
    
    {:src_language=>src_language, :src_code=>src_code}
  end
  
  protected
  
   def self.base_part_of(file_name) 
    File.basename(file_name).gsub(/[^\w._-]/, '') 
  end 
  
  def self.language(template_field)
    case UnitTest.base_part_of(template_field.original_filename)
      when /\.(c)$/
        $1
      when /\.(rb)$/
        'ruby'
    end
  end
end