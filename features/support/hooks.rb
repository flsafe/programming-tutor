Before do
  #Make sure there are some exercise sets in the DB!
  ll_set = ExerciseSet.create! :title=>'Linked List Basics', :description=>'Implement a linked list'
  ht_set = ExerciseSet.create! :title=>'Hash Table', :description=>'Implement a Hash Table'
  
  ll = Exercise.create! :title=>"Implementing A Singly Linked List", :description=>"An introduction to implementing linked lists"
  ht = Exercise.create :title=>"Implementing A Hash Table", :description=>"An introduction to implementing hash tables"
  
  ll_set.exercises << ll
  ll_set.save
  ht_set.exercises << ht
  ht_set.save
end