require 'spec_helper'

describe Exercise do
  before(:each) do
    @exercise ||= Factory.build :exercise
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
  
  describe "#new_unit_test_attributes=" do
    
    it "adds a new unit test object" do
      unit_test = Factory.build :unit_test, :src_language=>'monkeypoop', :src_code=>'for(;;;) poop()'
      
      @exercise.new_unit_test_attributes = [unit_test.attributes]
      (@exercise.unit_tests.select {|ut| ut.src_language == unit_test.src_language and 
        ut.src_code == unit_test.src_code}).should have(1).items
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
      (@exercise.unit_tests.select {|ut| ut == @unit_test}).should have(0).items
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