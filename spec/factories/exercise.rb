Factory.sequence :exercise_title do |n|
  "Ex #{n}"
end

Factory.define :exercise do |e|
  e.title {Factory.next :exercise_title}
  e.description 'description'
end