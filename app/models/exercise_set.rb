class ExerciseSet < ActiveRecord::Base
  acts_as_taggable
  acts_as_taggable_on :algorithms, :data_structures
 
  has_and_belongs_to_many :completed_users, :class_name=>"User"
  has_many :exercises, :dependent=>:nullify
  
  validates_presence_of :title, :description
  validates_uniqueness_of :title

  def self.random_incomplete_set_for(user)
    completed_set_ids = user.completed_sets(true).map {|e| e.id}
    completed_set_ids << 0 #Query below won't work if completed set ids is empty 
    incomplete_sets = ExerciseSet.find(:all, 
                                        :select=>:id, 
                                        :conditions=>["id NOT IN (?)", completed_set_ids])
    if not incomplete_sets.empty? 
      random_set_id = incomplete_sets[rand(incomplete_sets.count)].id
      return ExerciseSet.find_by_id(random_set_id) 
    end
  end
end
