class GradeSolutionJob < Struct.new :code, :user_id, :exercise_id
  
  Result = Struct.new(:in_progress, :error_message, :grade_sheet) 
  
  def perform
    begin
      get_exercise_solution_template
      get_exercise_unit_test
      solution_code = fill_in_solution_template
      results       = execute_unit_test_on_code(solution_code)
      place_results(results)
    rescue Exception => e
      Rails.logger.error(e.message)
      JobResult.place_result(:user_id=>user_id, :exercise_id=>exercise_id, :error_message=>e.message, :job_type=>'grade')
    end
  end
  
  def self.get_latest_result(user_id, exercise_id)
    grade_result = Result.new 
    job_result = JobResult.get_latest_result(:user_id=>user_id, :exercise_id=>exercise_id, :job_type=>'grade')
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
     @unit_test = UnitTest.for_exercise(exercise_id).written_in('ruby').first
    raise "Unit test not found" unless @unit_test
  end
  
  def fill_in_solution_template
    solution_code = @template.fill_in(code)
  end
  
  def place_results(results)
    if results[:error]
        JobResult.place_result(:user_id=>user_id, :exercise_id=>exercise_id, :error_message=>results[:error], :job_type=>'grade')
    else
        save_grade_sheet(results)
        JobResult.place_result(:user_id=>user_id, :exercise_id=>exercise_id, :data=>'OK', :error_message=>nil, :job_type=>'grade')
    end
  end
  
  def execute_unit_test_on_code(solution_code)
    @unit_test.run_on(solution_code)
  end
  
  def save_grade_sheet(results)
    time_stat   = Statistic.get_stat('user.time_taken', user_id)
    grade_sheet = GradeSheet.new :grade=>results[:grade], :user_id=>user_id, :exercise_id=>exercise_id, :unit_test_results=>results, :src_code=>code, :time_taken=>time_stat.to_i
    user = User.find(user_id)
    user.grade_sheets << grade_sheet
  end

  def debug_mode
    file_handle = File.open("log/#{Rails.env}_delayed_jobs.log", (File::WRONLY | File::APPEND | File::CREAT))
    file_handle.sync = true
    Rails.logger.auto_flushing = true
    Rails.logger.instance_variable_set :@log, file_handle
    Delayed::Worker.logger = Rails.logger
  end
end
