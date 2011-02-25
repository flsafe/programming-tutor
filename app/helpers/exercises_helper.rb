module ExercisesHelper
  
  def add_model_link(title, replace_id, render_opts)
    link_to_function title do |page|
      page.insert_html( :bottom, replace_id, render_opts)
    end
  end

  def grade_to_class(grade)
    clas = "grade-a"
    if grade.to_i != 100
      clas = "grade-other"
    end
    clas
  end
end
