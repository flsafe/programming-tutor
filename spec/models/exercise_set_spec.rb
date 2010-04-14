require 'spec_helper'

class User;end

describe ExerciseSet do
  before(:each) do
    @exercise_set = ExerciseSet.new :title=>'LinkedList', :description=>'Implement'
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
      @new_user = mock_model(User)
      ExerciseSet.create :title=>'LinkedList', :description=>'Implement'
      ExerciseSet.create :title=>'HashTable', :description=>'Implement'
      ExerciseSet.create :title=>'PrimeNumbers', :description=>'Detect Primes'
      ExerciseSet.create :title=>'Graphic', :description=>'Draw circle'
    end
    
    context "when the user has not completed any exercises" do
      it "recommends (n) random exercise sets, no duplicates" do
        n = 3
        1.upto(3) do
          exercise_sets = ExerciseSet.recommend(@new_user.id, n)
          exercise_sets.size.should == n
        
          have_seen = Hash.new(0)
          exercise_sets.each do |set|
            have_seen[set] += 1
            have_seen[set].should_not >= n
          end
        end
      end
    end
    
    context "when (n) exercises are requested and (n) > ExerciseSet.count" do 
      it "returns ExerciseSet.count exercise sets" do
        exercise_sets = ExerciseSet.recommend(@new_user, 100)
        exercise_sets.size.should == ExerciseSet.count
      end
    end
  end
end
