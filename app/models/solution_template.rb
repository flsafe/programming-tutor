class SolutionTemplate < ActiveRecord::Base
  belongs_to :exercise
  
  validates_presence_of :src_language, :src_code
  
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
  
  def self.language(template_field)
    case UnitTest.base_part_of(template_field.original_filename)
      when /\.(c)$/
        $1
      when /\.(rb)$/
        'ruby'
    end
  end
  
  def self.base_part_of(file_name) 
    File.basename(file_name).gsub(/[^\w._-]/, '') 
  end 
end