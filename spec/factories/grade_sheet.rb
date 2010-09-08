unit_test_results =<<DOC
grade: 100
tests: 
  test1:
    expected:1
    got:1
    points:20
DOC

Factory.define :grade_sheet do |gs|
  gs.association :user
  gs.association :exercise
  gs.grade 100.0
  gs.unit_test_results unit_test_results
  gs.src_code "int main(){return 0;}"
  gs.time_taken 15
end

Factory.define :set_grade_sheet do |gs|
  gs.association :user
  gs.association :exercise_set
  gs.grade 100.0
end