Before do
  #Make sure there are some exercise sets in the DB!
  ExerciseSet.create! :title=>'Linked Lists', :description=>'Implement a linked list'
  ExerciseSet.create! :title=>'Hash Table', :description=>'Implement a Hash Table'
end