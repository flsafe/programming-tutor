require 'spec_helper'

describe ExerciseSet do
  before(:each) do
    @valid_attributes = {
      :title=>'LinkedList', :description=>'Implement'
    }
    @exercise_set = ExerciseSet.create! @valid_attributes
  end

  
  it 'is valid with valid attributes' do
    @exercise_set.should be_valid
  end
  
  it "is not valid without a title" do
    @exercise_set.title = nil
    @exercise_set.should_not be_valid
  end
  
  it "is not valid without a description" do
    @exercise_set.description = nil
    @exercise_set.should_not be_valid
  end
end
