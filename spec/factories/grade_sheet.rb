Factory.define :grade_sheet do |gs|
  gs.association :user
  gs.association :exercise
  gs.grade 100.0
  gs.unit_test_results "{'test'=>20}"
  gs.src_code "int main(){return 0;}"
end

Factory.define :set_grade_sheet do |gs|
  gs.association :user
  gs.association :exercise_set
  gs.grade 100.0
end