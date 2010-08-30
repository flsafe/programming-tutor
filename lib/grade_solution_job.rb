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
        Rails.logger.error(results[:error])
        JobResult.place_result(:user_id=>user_id, :exercise_id=>exercise_id, :error_message=>results[:error], :job_type=>'grade')
      else
        raise "Grade sheet could not be saved" unless save_grade_sheet(results, code)
        JobResult.place_result(:user_id=>user_id, :exercise_id=>exercise_id, :data=>'OK', :error_message=>nil, :job_type=>'grade')
      end
    rescue Exception => e
      Rails.logger.error(e.message)
      JobResult.place_result(:user_id=>user_id, :exercise_id=>exercise_id, :error_message=>e.message, :job_type=>'grade')
    end
  end
  
  def self.pop_result(user_id, exercise_id)
    r_struct     = Struct.new("GradeJobResult", :in_progress, :error_message, :grade_sheet)
    grade_result = r_struct.new 
    
    r = JobResult.pop_result(:user_id=>user_id, :exercise_id=>exercise_id, :job_type=>'grade')
    if r
      grade_result.error_message = r.error_message
      gs                         = GradeSheet.find :first, :conditions=>{:user_id=>user_id, :exercise_id=>exercise_id}, :order=>'created_at DESC'
      grade_result.grade_sheet   = gs
    else
      grade_result.in_progress   = true      
    end

    grade_result
  end

  protected
  
  def save_grade_sheet(results, code)  
    grade_sheet = GradeSheet.new :grade=>results[:grade], :user_id=>user_id, :exercise_id=>exercise_id, :unit_test_results=>results, :src_code=>code
    ta          = TeachersAid.new    
    ta.record_grade grade_sheet
    grade_sheet.id
  end
end