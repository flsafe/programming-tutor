class GradeSolutionJob < Struct.new :code, :user_id, :exercise_id
  def perform
    template = SolutionTemplate.find_by_exercise_id(exercise_id)
    template.fill_in(code)

    if template.syntax_error?
      
    else
      unit_test = UnitTest.find_by_exercise_id(exercise_id)
      results   = unit_test.run_on(template)
    end
  end
  
  protected
  
  def bail_on_error(msg)
    
  end
end