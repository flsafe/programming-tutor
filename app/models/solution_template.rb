class SolutionTemplate < ActiveRecord::Base
  belongs_to :exercise
  
  validates_presence_of :src_language, :src_code
  
  named_scope :written_in, lambda {|lang| {:conditions=>{:src_language=>lang}}}
  
  named_scope :for_exercise, lambda{|exercise_id| {:conditions=>{:exercise_id=>exercise_id}}}
  
  attr_reader :filled_in_src_code

  @@PROTOTYPE_REGEX = /\/\*start_prototype\*\/(.*)\/\*end_prototype\*\//m
  
  def fill_in(solution_code)
    solution_code = CozyStringUtils.escape_back_slashes(solution_code)
    @filled_in_src_code = src_code.gsub(@@PROTOTYPE_REGEX, solution_code).strip
  end
  
  def prototype
    m = src_code.match(@@PROTOTYPE_REGEX)
    if m and m[1]
      m[1]
    else
      ""
    end
  end
  
   def solution_template_file=(template_file)
    self.attributes = SolutionTemplate.from_file_field(template_file)
  end
  
  def self.from_file_field(template_field)
    return unless template_field
    #TODO: Support solution templates in other languages
    src_language = 'c' 
    src_code     = template_field.read

    {:src_language=>src_language, :src_code=>src_code}
  end
  
  protected
end
