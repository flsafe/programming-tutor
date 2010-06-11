class GradeSolutionJob < Struct.new :code, :user_id, :exercise_id
  
  def perform
    template = SolutionTemplate.find_by_exercise_id(exercise_id)
    template.fill_in(code)
    if template.syntax_error?
      post_result("Your solution did not compile! Check your syntax.")
    else
      results = run_unit_tests_on(template)
      if results[:error]
        post_result(results[:error], nil)
      else
        gs_id   = save_grade_sheet(results, code)
        post_result(nil, gs_id)
      end
    end
  end
  
  protected
  
   def post_result(error_message = nil, grade_sheet_id = nil)
     GradeSolutionResult.delete_all ['user_id=? AND exercise_id=?', user_id, exercise_id]
     grade_solution_result = GradeSolutionResult.new :user_id=>user_id, :exercise_id=>exercise_id, :error_message=>error_message, :grade_sheet_id=>grade_sheet_id
     grade_solution_result.save!
  end
  
  def run_unit_tests_on(template)
    unit_test   = UnitTest.find_by_exercise_id(exercise_id)
    results     = unit_test.run_on(template)
    results
  end
  
  def save_grade_sheet(results, code)
    ta          = TeachersAid.new
    grade_sheet = GradeSheet.new :grade=>results[:grade], :user_id=>user_id, :exercise_id=>exercise_id, :unit_test_results=>results, :src_code=>code
    ta.record_grade grade_sheet
    grade_sheet.id
  end

end