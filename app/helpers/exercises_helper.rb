module ExercisesHelper
  
  def add_model_link(title, replace_id, render_opts)
    link_to_function title do |page|
      page.insert_html( :bottom, replace_id, render_opts)
    end
  end
end