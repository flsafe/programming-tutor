require 'spec_helper'

describe Exercise do
  before(:each) do
    @exercise ||= Factory.build(:exercise)
    @src_code     = 'source_code'
    @src_language = 'ruby'
  end

  describe "#sample?" do
    it "returns true if the exercise's title in in app_config['demo_exercise_titles']" do
      APP_CONFIG['demo_exercise_titles'] = ["My Exercise", "TestMe"]
      exercise = Factory.create :exercise, :title=>"My Exercise"
      exercise.sample?.should == true
    end

    it "returns false if the exercises title is not in APP_CONFIG[demo_exercise_titles]"do
      APP_CONFIG['demo_exercise_titles'] = ["Should not be found"]
      exercise = Factory.create :exercise, :title=>"Ex1"
      exercise.sample?.should == false
    end
  end

  describe "#new_hint_attributes=" do
    
    it "adds a new hint object to the hints list" do
      hint = Factory.build :hint, :text=>'Hello!'
      
      @exercise.new_hint_attributes = [hint.attributes]
      (@exercise.hints.select {|h| h.id == hint.id and h.text == hint.text }).should have(1).items
    end
  end
  
  describe "#existing_hint_attributes=" do
    
    before(:each) do
      @exercise.hints = existing(:hint, 4)
      @hint           = @exercise.hints[2]
    end
    
    it "updates the hint objects specified in the attributes array" do
      @exercise.existing_hint_attributes = update_existing(@hint.id, {:text=>"New Style"})
      (@exercise.hints.select {|h| h.id == @hint.id and h.text == @hint.text}).should have(1).items
    end
    
    it "destroys hint objects that are removed from the attributes array" do
      @exercise.existing_hint_attributes = update_existing(@hint.id, {}, {:delete=>true})
      (@exercise.hints.select {|h| h == @hint}).should have(0).items
    end
  end
  
  describe  "#new_template_attributes=" do
    
    it "adds a template object" do
      template = stub_model(SolutionTemplate, :src_language=>'java', :src_code=>'public static void main(String args[]){;}')
      @exercise.new_solution_template_attributes = [template.attributes]
      
      (@exercise.solution_templates.select {|t| t.src_language == template.src_language and
        t.src_code == template.src_code}).should have(1).items
    end
    
    context "from file" do
      it "adds a template object" do
        template = stub_model(SolutionTemplate, :src_language=>@src_language, :src_code=>@src_code)
        SolutionTemplate.stub(:from_file_field).and_return(template.attributes)

        @exercise.new_solution_template_attributes = [:solution_template_file=>nil]
      
        (@exercise.solution_templates.select {|t| t.src_language == template.src_language and
          t.src_code == template.src_code}).should have(1).items
      end
    end
  end
  
  describe "#existing_template_attributes" do
    
    before(:each) do
      @exercise.solution_templates = existing(:solution_template, 4)
      @template = @exercise.solution_templates[2]
    end
    
    it "updates an existing template objects" do
     @exercise.existing_solution_template_attributes = update_existing(@template.id, {:src_code=>"cool code()"})
      (@exercise.solution_templates.select {|ut| ut.src_code == @template.src_code}).should have(1).items
    end
    
    it "removes existing templtes not specified in the templates attributes" do
      @exercise.existing_solution_template_attributes = update_existing(@template.id, {}, {:delete=>true})
      (@exercise.solution_templates.select {|ut| ut.id == @template.id}).should have(0).items
    end
  end
  
  describe "#new_unit_test_attributes=" do
    
    it "adds a new unit test object" do
      unit_test = Factory.build :unit_test, :src_language=>'monkeypoop', :src_code=>'for(;;;) poop()'
      
      @exercise.new_unit_test_attributes = [unit_test.attributes]
      (@exercise.unit_tests.select {|ut| ut.src_language == unit_test.src_language and 
        ut.src_code == unit_test.src_code}).should have(1).items
    end
    
    context "from file" do
      it "adds a new unit test object" do
        file = mock(:file, :original_file_name=>"unit_test.rb", :read=>"unit test code",:to_str=>"unit_test.rb", :to_s=>"unit_test.rb").as_null_object
        @exercise.new_unit_test_attributes = [:unit_test_file=>file]
        
        (@exercise.unit_tests.select {|ut| ut.src_language == "ruby" and 
          ut.src_code == "unit test code"}).should have(1).items
      end
    end
  end
  
  describe "#existing_unit_test_attributes" do
    
    before(:each) do
      @exercise.unit_tests = existing(:unit_test, 4)
      @unit_test           = @exercise.unit_tests[2]
    end
    
    it "updates unit_test_objects specified in the attributes array" do
      @exercise.existing_hint_attributes = update_existing(@unit_test.id, {:src_code=>"cool code()"})
      (@exercise.unit_tests.select {|ut| ut.src_code == @unit_test.src_code}).should have(1).items
    end
    
    it "removes existing unit tests not specifed in the unit test attributes" do
      @exercise.existing_unit_test_attributes = update_existing(@unit_test.id, {}, {:delete=>true})
      (@exercise.unit_tests.select {|ut| ut.id == @unit_test.id}).should have(0).items
    end
  end

  
  describe "#new_exercise_set_attributes" do
    it "assigns the exercise_set " do
      exercise_set = Factory.build :exercise_set, :title=>'donkeypoop', :description=>'description'
      @exercise.new_exercise_set_attributes = exercise_set.attributes
      @exercise.exercise_set.title.should == exercise_set.title
      @exercise.exercise_set.description.should == exercise_set.description
    end
  end
  
  
  def existing(object_sym, n)
    return @existing if @existing
    @existing = []
    n.times {@existing << Factory.create(object_sym)}
    @existing
  end
  
  def update_existing(id = nil, attributes = nil, options = {:delete=>false})
    if options[:delete]
      @existing = @existing.reject {|obj| obj.id == id }
    else
      obj = @existing.detect {|obj| obj.id == id}
      obj.attributes  = attributes
    end
    to_attributes(@existing)
  end
  
  def to_attributes(hints)
    attributes = {}
    hints.each {|h| attributes[h.id.to_s] = h.attributes}
    attributes
  end
end
