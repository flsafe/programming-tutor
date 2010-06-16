class GradeSolutionJob < Struct.new :code, :user_id, :exercise_id
  
  def perform
    begin
      FileUtils.mkdir_p(APP_CONFIG['work_dir'])
    
      template  = SolutionTemplate.find :first, :conditions=>['exercise_id=? AND src_language=?', exercise_id, 'c']
      unless template
        raise "Could not find the template solution template associated with this exercise!"
      end

      unit_test = UnitTest.find :first, :conditions=>['exercise_id=? AND src_language=?', exercise_id, 'rb']
      unless unit_test
        raise "Could not find the unit test associated with this exercise!"
      end
    
      solution_code = template.fill_in(code)
      results       = unit_test.run_on(solution_code)
      if results[:error]
        post_result(humanize(results[:error]), nil)
      else
        gs_id   = save_grade_sheet(results, code)
        post_result(nil, gs_id)
      end
    rescue Exception => e
      post_result("My codes have failed! An error occured while preparing the grade your solution. Sorry about that, I'm working on it. Try again a little later!")
    end
  end
  
  def humanize(error_message)
    case error_message
      when :did_not_compile     then "Your solution did not compile! Check your syntax"
      when :no_result_returned  then "My codes have failed! An error occured while grading your solution. I'm working on it. Try again later!"
      else error_message.to_s
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