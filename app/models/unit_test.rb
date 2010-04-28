class UnitTest < ActiveRecord::Base
  belongs_to :exercise
  
  validates_presence_of :src_language, :src_code
  
  def self.from_file_field(unit_test_field)
    return unless unit_test_field
    ut = UnitTest.new
    ut.src_language = UnitTest.language(unit_test_field)
    ut.src_code     = unit_test_field.data
    ut
  end
  
  private
  
  def self.language(unit_test_field)
    case UnitTest.base_part_of(unit_test_field.original_filename)
      when /\.(c)$/
        $1
    end
  end
  
  def self.base_part_of(file_name) 
    File.basename(file_name).gsub(/[^\w._-]/, '') 
  end 
end