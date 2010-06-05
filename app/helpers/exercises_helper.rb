module ExercisesHelper
  
  def add_model_link(title, replace_id, with_partial, object)
    link_to_function title do |page|
      page.insert_html :bottom, replace_id, :partial=>with_partial, :object=>object
    end
  end
  
  def add_hint_link
    link_to_function "Add Hint" do |page| 
			page.insert_html :bottom, :hints, :partial=>'hint', :object=>Hint.new
	  end
  end
  
  def add_unit_test_link
    link_to_function "Add Unit Test" do |page|
      page.insert_html :bottom, :unit_tests, :partial=>'unit_test', :object=>UnitTest.new
    end
  end
  
  def add_figure_link
    link_to_function "Add Figure" do |page|
      page.insert_html :bottom, :figures, :partial=>'figure', :object=>Figure.new
    end
  end
  
  def add_template_link
    link_to_function "Add Template" do |page|
      page.insert_html :bottom, :templates, :partial=>'code_template', :object=>Template.new
    end
  end
end