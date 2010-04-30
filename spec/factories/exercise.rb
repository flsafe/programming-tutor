Factory.sequence :exercise_title do |n|
  "Ex #{n}"
end

Factory.define :exercise do |e|
  e.title {Factory.next :exercise_title}
  e.description 'description'
  e.problem 'problem text'
  e.tutorial 'tutorial text'
  e.hints {|e| [e.association(:hint) ]}
  e.minutes '60'
  e.unit_tests {|e| [e.association(:unit_test)]}
  #todo: tags need to be included?
end