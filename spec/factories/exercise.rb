Factory.sequence :exercise_title do |n|
  "Ex #{n}"
end

Factory.define :exercise do |e|
  e.title {Factory.next :exercise_title}
  e.description 'description'
  e.problem 'problem text'
  e.tutorial 'tutorial text'
  e.minutes '60'
  #todo: unit test file using paperclip
  #todo: tags need to be validated
end