class GradeSolutionJob < Struct.new :code, :user_id, :exercise_id
  
  def perform
    template = SolutionTemplate.find_by_exercise_id(exercise_id)
    template.fill_in(code)
    if template.syntax_error?
      post_result("Your solution did not compile! Check your syntax.", :did_not_compile, nil)
    else
      grade_sheet = run_unit_tests_on(exercise_id, template)
      ta          = TeachersAid.new
      ta.record_grade grade_sheet
      post_result("Success!", nil, grade_sheet.id)
    end
  end
  
  protected
  
  def run_unit_tests_on(ex_id, template)
    unit_test   = UnitTest.find_by_exercise_id(ex_id)
    results     = unit_test.run_on(template)
    grade_sheet = GradeSheet.new :grade=>results[:grade], :user_id=>user_id, :exercise_id=>exercise_id
    grade_sheet.unit_test_results = results
    grade_sheet
  end
  
  def post_result(message, error_msg = nil, grade_sheet_id=nil)
     grade_solution_result = GradeSolutionResult.new :message=>message, :error=>error_msg, :grade_sheet_id=>grade_sheet_id
     grade_solution_result.save
  end

end