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

  describe '#recommend' do
    before(:each) do
      @new_user = stub_model(User)
      ExerciseSet.create! :title=>'LinkedList', :description=>'Implement'
      ExerciseSet.create! :title=>'HashTable', :description=>'Implement'
      ExerciseSet.create! :title=>'PrimeNumbers', :description=>'Detect Primes'
      ExerciseSet.create! :title=>'Graphic', :description=>'Draw circle'
    end

    it "recommends (n) random exercise sets, no duplicates" do
      n = 3
      1.upto(3) do
        exercise_sets = ExerciseSet.recommend(@new_user.id, n)
        exercise_sets.size.should == n
        should_not_have_duplicate(exercise_sets)
      end
    end

    context "when (n) exercises are requested and (n) > ExerciseSet.count" do 
      it "returns ExerciseSet.count exercise sets" do
        exercise_sets = ExerciseSet.recommend(@new_user, 100)
        exercise_sets.size.should == ExerciseSet.count
      end
    end
    
    def should_not_have_duplicate(exercise_sets)
      have_seen = Hash.new(0)
        exercise_sets.each do |set|
          have_seen[set] += 1
          have_seen[set].should <= 1
        end
    end
  end
end
