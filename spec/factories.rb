Factory.sequence :exercise_set_title do |n|
  "Basics #{n}"
end
Factory.sequence :exercise_title do |n|
  "Ex #{n}"
end
Factory.sequence :email do |n|
  "user#{n}@mail.com"
end
Factory.sequence :username do |n|
  "user #{n}"
end

Factory.define :user do |u|
  u.username Factory.next :username
  u.password 'password'
  u.password_confirmation 'password'
  u.email Factory.next :email
end

Factory.define :grade_sheet do |gs|
  gs.association :user
  gs.association :gradeable, :factory=>:exercise
  gs.grade 100.0
end

Factory.define :exercise_set do |set|
  set.title Factory.next :exercise_set_title
  set.description "Basics description"
end

Factory.define :exercise do |e|
  e.title Factory.next :exercise_title
  e.description 'description'
end