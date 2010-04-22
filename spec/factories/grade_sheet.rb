Factory.define :grade_sheet do |gs|
  gs.association :user
  gs.association :exercise, :factory=>:exercise
  gs.grade 100.0
end