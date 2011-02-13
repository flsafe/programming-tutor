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
  
  validates_presence_of :title, :description, :problem, :tutorial, :minutes, :unit_tests, :exercise_set
  validates_associated  :hints, :unit_tests, :exercise_set, :solution_templates
  
  validates_uniqueness_of :title

  def sample?
    titles = APP_CONFIG['demo_exercise_titles']
    titles.detect {|t| t == self.title} != nil
  end

  def get_stat(name)
    Statistic.get_stat("exercise.#{name}", self.id) || 0
  end
end
