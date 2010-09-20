class GradeSolutionJob < Struct.new :code, :user_id, :exercise_id
  
  def perform
    begin
      FileUtils.mkdir_p(APP_CONFIG['work_dir'])
    
      get_exercise_solution_template
      get_exercise_unit_test
      solution_code = fill_in_solution_template
      results       = execute_unit_test_on_code(solution_code)

      if results[:error]
        Rails.logger.error(results[:error])
        JobResult.place_result(:user_id=>user_id, :exercise_id=>exercise_id, :error_message=>results[:error], :job_type=>'grade')
      else
        save_grade_sheet(results)
        JobResult.place_result(:user_id=>user_id, :exercise_id=>exercise_id, :data=>'OK', :error_message=>nil, :job_type=>'grade')
      end
    rescue Exception => e
      puts e.message if Rails.env == "development"
      Rails.logger.error(e.message)
      JobResult.place_result(:user_id=>user_id, :exercise_id=>exercise_id, :error_message=>e.message, :job_type=>'grade')
    end
  end
  
  def self.pop_result(user_id, exercise_id)
    r_struct     = Struct.new("GradeJobResult", :in_progress, :error_message, :grade_sheet)
    grade_result = r_struct.new 
    
    job_result = JobResult.pop_result(:user_id=>user_id, :exercise_id=>exercise_id, :job_type=>'grade')
    if job_result
      grade_result.error_message = job_result.error_message
      grade_sheet                = GradeSheet.find :first, :conditions=>{:user_id=>user_id, :exercise_id=>exercise_id}, :order=>'created_at DESC'
      grade_result.grade_sheet   = grade_sheet
    else
      grade_result.in_progress   = true      
    end

    grade_result
  end

  protected
  
  def get_exercise_solution_template
    @template  = SolutionTemplate.for_exercise(exercise_id).written_in('c').first
    raise "Solution template not found" unless @template
  end
  
  def get_exercise_unit_test
     @unit_test = UnitTest.for_exercise(exercise_id).written_in('rb').first
    raise "Unit test not found" unless @unit_test
  end
  
  def fill_in_solution_template
    solution_code = @template.fill_in(code)
  end
  
  def execute_unit_test_on_code(solution_code)
    @unit_test.run_on(solution_code)
  end
  
  def fill_in_template_and_execute_unit_test
    solution_code = @template.fill_in(code)
    @unit_test.run_on(solution_code)
  end
  
  def save_grade_sheet(results)
    time_stat   = Statistic.get_stat('user.time_taken', user_id)
    grade_sheet = GradeSheet.new :grade=>results[:grade], :user_id=>user_id, :exercise_id=>exercise_id, :unit_test_results=>results, :src_code=>code, :time_taken=>time_stat.to_i
    grade_sheet.save!
  end
end