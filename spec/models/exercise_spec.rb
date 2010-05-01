require 'spec_helper'

describe Exercise do
  before(:each) do
    @exercise ||= Factory.build :exercise
  end
  
  describe "#new_hint_attributes=" do
    
    it "adds a new hint object to the hints list" do
      hint = Factory.build :hint, :text=>'Hello!'
      
      @exercise.new_hint_attributes = [hint.attributes]
      (@exercise.hints.any? {|h| h.text == hint.text }).should == true
    end
  end
  
  describe "#existing_hint_attributes=" do
    before(:each) do
      @exercise.hints = existing_hints(4)
    end
    
    it "updates the hint objects specified in the attributes array" do
      hint = existing_hints[2]
      @exercise.existing_hint_attributes = update_hint_attributes(hint.id, "New Style Text Fool!")
      (@exercise.hints.select {|h| h.id == hint.id and h.text == hint.text}).should have(1).items
    end
    
    it "destroys hint objects that are removed from the attributes array" do
      hint = existing_hints[2]
      @exercise.existing_hint_attributes = update_hint_attributes(hint.id, "", :del=>true)
      (@exercise.hints.select {|h| h.id == hint.id}).should have(0).items
    end
  end
  
  describe "#new_unit_test_attributes=" do
    
    it "does something" do
    end
  end

  
  def existing_hints(n = 0) 
    return @hints if @hints
    @hints = []
    n.times {@hints << Factory.create(:hint)}
    @hints
  end
  
  def update_hint_attributes(id, text = nil, options = {:del=>false})
    if options[:del]
      @hints = existing_hints.reject {|h| h.id == id}
    else
      hint       = @hints.detect {|h| h.id == id}
      hint.text  = text
    end
    to_attributes(existing_hints)
  end
  
  def to_attributes(hints)
    attributes = {}
    hints.each {|h| attributes[h.id.to_s] = h.attributes}
    attributes
  end
end