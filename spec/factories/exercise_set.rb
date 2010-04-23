Factory.sequence :exercise_set_title do |n|
  "Basics #{n}"
end

Factory.define :exercise_set do |e|
  e.title {Factory.next :exercise_set_title}
  e.description "Basics description"
end

Factory.define :complete_exercise_set, :parent=>:exercise_set do |e|
  e.exercises {|e| [e.association(:exercise), e.association(:exercise)]}
end