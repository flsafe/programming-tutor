Factory.sequence :exercise_set_title do |n|
  "Basics #{n}"
end

Factory.define :exercise_set do |set|
  set.title Factory.next :exercise_set_title
  set.description "Basics description"
end