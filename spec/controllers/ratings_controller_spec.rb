require 'spec_helper'

describe RatingsController do
  before(:each) do
    Exercise.stub(:find).and_return(stub_exercise(:minutes=>60))
    controller.stub(:current_user).and_return(current_user)
  end
  
  def current_user(stubs={})
    @current_user ||= stub_model(User, stubs)
  end
  
  def stub_exercise(stubs={})
    @stub_exercise ||= stub_model(Exercise, stubs)
  end

  def rating_value(rating_str)
    rating_str = rating_str.sub(/\-/, '_')
    rating = APP_CONFIG['rating_values'][rating_str]
  end
  
  describe "create" do
    before(:each) do
    end

    it "creates a new rating" do
      Rating.should_receive("create!").with(:user_id=>current_user.id,
                                            :exercise_id=>stub_exercise.id.to_s,
                                            :rating=>rating_value('too-easy'))

      post "create", :user_id=>current_user.id,
                     :exercise_id=>stub_exercise.id,
                     :rating=>'too-easy'
    end
  end

  it "does not allow more than one rating for the same exercise" do
    Rating.should_receive("create!").with(:user_id=>current_user.id,
                                          :exercise_id=>stub_exercise.id.to_s,
                                          :rating=>rating_value('too-easy')).once

    post "create", :user_id=>current_user.id,
                   :exercise_id=>stub_exercise.id,
                   :rating=>'too-easy'

    post "create", :user_id=>current_user.id,
                   :exercise_id=>stub_exercise.id,
                   :rating=>'too-easy'
  end
    
end
