class GradeSolutionJob < Struct.new :code, :user_id, :exercise_id
  def perform
    template = SolutionTemplate.find_by_exercise_id(exercise_id)
    template.fill_in(code)
    if template.syntax_error?
      
    else
    end
  end
end