module ExercisesHelper
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
    link_to_function "Add Figure Test" do |page|
      page.insert_html :bottom, :figures, :partial=>'figure', :object=>Figure.new
    end
  end
end