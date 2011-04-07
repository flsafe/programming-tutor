class Exercise < ActiveRecord::Base  
  acts_as_taggable
  acts_as_taggable_on :algorithms, :data_structures

  has_many :hints, :dependent=>:destroy
  has_many :solution_templates, :dependent=>:destroy
  has_many :unit_tests, :dependent=>:destroy
  has_many :completed_users, :through=>:grade_sheets, :source=>:user, :uniq=>true #todo: wtf does this imply?
  has_many :grade_sheets, :dependent=>:destroy
  has_many :exercise_sessions
  has_and_belongs_to_many :dinner_guests, :class_name=>"User"

  belongs_to :exercise_set  
  
  after_update :save_associates
  
  validates_presence_of :title, :description, :problem, :tutorial, :minutes, :unit_tests, :order
  validates_associated  :hints, :unit_tests, :exercise_set, :solution_templates
  
  validates_uniqueness_of :title
    
  def sample?
    titles = APP_CONFIG['demo_exercise_titles']
    titles.detect {|t| t == self.title} != nil
  end

  def new_solution_template_attributes=(attributes)
    new_attributes_for(:solution_templates, attributes)
  end
  
  def new_hint_attributes=(attributes)
    new_attributes_for(:hints, attributes)
  end
  
  def new_unit_test_attributes=(unit_test_attributes)
    new_attributes_for(:unit_tests, unit_test_attributes)
  end

  def new_exercise_set_attributes=(new_exercise_set_attributes)
    #A new exercise set hash is not always returned from the client, sometimes one is chosen from the select dropdown.
    self.exercise_set = build_exercise_set new_exercise_set_attributes unless new_exercise_set_attributes['title'].blank?
  end
  
  def existing_solution_template_attributes=(template_attributes)
    existing_attributes_for(:solution_templates, template_attributes)
  end
  
  def existing_hint_attributes=(hint_attributes)
   existing_attributes_for(:hints, hint_attributes)
  end
  
  def existing_unit_test_attributes=(unit_test_attributes)
    existing_attributes_for(:unit_tests, unit_test_attributes)
  end
  
  def get_stat(name)
    Statistic.get_stat("exercise.#{name}", self.id) || 0
  end
  
  protected
    
  def new_attributes_for(association, attributes)
    associates = self.send(association)
    attributes.each do |atts|
      associates.build atts
    end
  end
  
  def existing_attributes_for(association, associated_attributes)
    associates = self.send(association)
    associates.reject(&:new_record?).each do |associate|
      attributes = associated_attributes[associate.id.to_s]
      if attributes
        associate.attributes = attributes
      else
        associates.delete(associate)
      end
    end
  end
  
  def save_associates
    hints.each {|h| h.save(false)}
    unit_tests.each {|u| u.save(false)}
    solution_templates.each {|s| s.save(false)}
    exercise_set.save(false) if exercise_set # Some exercises temporarly don't belong to a set
  end
end
