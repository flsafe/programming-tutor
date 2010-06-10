class GradeSolutionJob < Struct.new :code, :user_id, :exercise_id
  
  def perform
    template = SolutionTemplate.find_by_exercise_id(exercise_id)
    template.fill_in(code)
    if template.syntax_error?
      post_result("Your solution did not compile! Check your syntax.", :did_not_compile, nil)
    else
      results = run_unit_tests_on(template)
      if results[:error]
        post_result("Your solution could not be graded!", results[:error], nil)
      else
        gs_id   = save_grade_sheet(results, code)
        post_result("Success!", nil, gs_id)
      end
    end
  end
  
  protected
  
   def post_result(message, error_msg = nil, grade_sheet_id=nil)
     grade_solution_result = GradeSolutionResult.new :message=>message, :error=>error_msg, :grade_sheet_id=>grade_sheet_id
     grade_solution_result.save
  end
  
  def run_unit_tests_on(template)
    unit_test   = UnitTest.find_by_exercise_id(exercise_id)
    results     = unit_test.run_on(template)
    results
  end
  
  def save_grade_sheet(results, code)
    ta          = TeachersAid.new
    grade_sheet = GradeSheet.new :grade=>results[:grade], :user_id=>user_id, :exercise_id=>exercise_id
    grade_sheet.unit_test_results = results
    grade_sheet.src_code          = code
    ta.record_grade grade_sheet
    grade_sheet.id
  end

end