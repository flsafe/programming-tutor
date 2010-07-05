class GradeSolutionJob < Struct.new :code, :user_id, :exercise_id
  
  def perform
    begin
      FileUtils.mkdir_p(APP_CONFIG['work_dir'])
    
      template  = SolutionTemplate.for_exercise(exercise_id).written_in('c').first
      raise "Solution template not found" unless template

      unit_test = UnitTest.for_exercise(exercise_id).written_in('rb').first
      raise "Unit test not found" unless unit_test
    
      solution_code = template.fill_in(code)
      results       = unit_test.run_on(solution_code)

      if results[:error]
        post_result(results[:error], nil)
      else
        gs_id   = save_grade_sheet(results, code)
        post_result(nil, gs_id)
      end
    rescue Exception => e
      post_result(e.message)
    end
  end

  protected
  
   def post_result(error_message = nil, grade_sheet_id = nil)
     GradeSolutionResult.delete_all ['user_id=? AND exercise_id=?', user_id, exercise_id]
     grade_solution_result = GradeSolutionResult.new :user_id=>user_id, :exercise_id=>exercise_id, :error_message=>error_message, :grade_sheet_id=>grade_sheet_id
     grade_solution_result.save!
  end
  
  def save_grade_sheet(results, code)  
    grade_sheet = GradeSheet.new :grade=>results[:grade], :user_id=>user_id, :exercise_id=>exercise_id, :unit_test_results=>results, :src_code=>code
    ta          = TeachersAid.new    
    ta.record_grade grade_sheet
    grade_sheet.id
  end
end