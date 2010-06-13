class GradeSolutionJob < Struct.new :code, :user_id, :exercise_id
  
  def perform
    template  = SolutionTemplate.find_by_exercise_id(exercise_id)
    template.fill_in(code)
    if template.syntax_error?
      post_result("Your solution did not compile! Check your syntax. Error: #{template.syntax_error?}")
    else
      unit_test = UnitTest.find_by_exercise_id(exercise_id)
      results   = unit_test.run_on(template)
      File.open('out-perform-results', 'w') {|f| f.write(p results)}
      if results['error']
        File.open('out-results-with-error', 'w') {|f| f.write(results[:error])}
        post_result(results[:error], nil)
      else
        File.open('out-results-no-error', 'w') {|f| f.write("")}
        gs_id   = save_grade_sheet(results, code)
        post_result(nil, gs_id)
      end
    end
  end
  
  protected
  
   def post_result(error_message = nil, grade_sheet_id = nil)
     File.open('out-perform-post-result', 'w') {|f| f.write(error_message)}
     GradeSolutionResult.delete_all ['user_id=? AND exercise_id=?', user_id, exercise_id]
     grade_solution_result = GradeSolutionResult.new :user_id=>user_id, :exercise_id=>exercise_id, :error_message=>error_message, :grade_sheet_id=>grade_sheet_id
     grade_solution_result.save!
  end
  
  def save_grade_sheet(results, code)  
    File.open('out-save-grade_sheet', 'w') {|f| f.write("***RESULTS****\n#{results}\n*****CODE*****\n#{code}")}
    grade_sheet = GradeSheet.new :grade=>results['grade'], :user_id=>user_id, :exercise_id=>exercise_id, :unit_test_results=>results, :src_code=>code
    File.open('out-grade_sheet', 'w') {|f| f.write(grade_sheet.grade)}
    ta          = TeachersAid.new    
    ta.record_grade grade_sheet
    File.open('out-done-saveing-grade-sheet', 'w') {|f| f.write(grade_sheet.id)}
    grade_sheet.id
  end

end