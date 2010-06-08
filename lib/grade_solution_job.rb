class GradeSolutionJob < Struct.new :code, :user_id, :exercise_id
  def perform
    template = SolutionTemplate.find_by_exercise_id(exercise_id)
    template.fill_in(code)

    if template.syntax_error?
      r = GradeSolutionResult.new :message=>"Your solution did not compile! Check your syntax.", :error=>:did_not_compile
      r.save
    else
      unit_test   = UnitTest.find_by_exercise_id(exercise_id)
      results     = unit_test.run_on(template)
      grade_sheet = GradeSheet.new :grade=>results[:grade], :user_id=>user_id, :exercise_id=>exercise_id
      grade_sheet.unit_test_results = results
      ta = TeachersAid.new
      ta.record_grade grade_sheet
      
      grade_solution_result = GradeSolutionResult.new :message=>'Success!', :grade_sheet_id=>grade_sheet.id
      grade_solution_result.save
    end
  end
  
  protected

end