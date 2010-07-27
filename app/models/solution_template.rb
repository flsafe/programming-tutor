class SolutionTemplate < ActiveRecord::Base
  belongs_to :exercise
  
  validates_presence_of :src_language, :src_code
  
  named_scope :written_in, lambda {|lang| {:conditions=>{:src_language=>lang}}}
  
  named_scope :for_exercise, lambda{|exercise_id| {:conditions=>{:exercise_id=>exercise_id}}}
  
  attr_reader :filled_in_src_code
  
  def fill_in(solution_code)
    solution_code = solution_code.gsub(/\\/, '\\\\\\\\')
    @filled_in_src_code = src_code.gsub(/\/\*start_prototype\*\/(.*)\/\*end_prototype\*\//m, solution_code)
  end
  
  def prototype
    src_code =~ /\/\*start_prototype\*\/(.*)\/\*end_prototype\*\//m
    $1
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