require 'spec_helper'

describe TutorController do

  before do
    @current_user = Factory.create :user
    controller.stub(:current_user).and_return(@current_user)

    @exercise = Factory.build :exercise, :exercise_set_id=>nil
    @set = Factory.create :exercise_set 
    @set.exercises.push << @exercise
    @exercise.save
    
    Time.stub(:now).and_return(Time.parse('7:00'))
  end
  
  describe "get show" do
    
    context "the user has no current exercise session" do
      before do
        @current_user.plate.push(@exercise)
      end

      it "starts an exercise session" do
        @current_user.should_receive(:start_exercise_session).with(@exercise)
        get "show", :id=>@exercise.id
      end

      it "assigns the exercise that will be displayed" do
        get "show", :id=>@exercise.id
        assigns[:exercise].should == @exercise
      end

      it "assigns the exercise end time" do
        get 'show', :id=>@exercise.id
        assigns[:target_end_time].should == Time.now + @exercise.minutes * 60 # to seconds 
      end

      it "renders the show template" do
        get 'show', :id=>@exercise.id
        response.should render_template('show')
      end

      it "asigns a plate to the current user if they don't have one already" do
        @current_user.plate.replace([])
        @current_user.save
        get 'show', :id=>@exercise.id
        @current_user.plate.should_not == []
      end

      it "redirects if the exercise isn't on the plate and has no grade in the db" do
        created_unrelated_set
        get 'show', :id=>@unrelated_ex.id
        response.should redirect_to(:controller=>:overview)
      end

      it "does not redirect if the exercise  isn't on the plate and has a grade in the db" do
        @current_user.plate.replace([])
        @current_user.grade_sheets.push(Factory.build(:grade_sheet, :user_id=>@current_user.id, :exercise_id=>@exercise.id))
        get 'show', :id=>@exercise.id
        response.should render_template('show')
      end 

      def created_unrelated_set
        @unrelated_ex = Factory.build(:exercise, :exercise_set_id=>nil)
        @unrelated_set = Factory.create(:exercise_set)
        @unrelated_set.exercises.push(@unrelated_ex)
      end
    end

    context "the user already has an exercise session" do
      before do
        @current_user.start_exercise_session(@exercise)
        @current_user.plate.push(@exercise)
      end

      it "does not start a new exercise session" do
        get "show", :id=>@exercise.id
        @current_user.exercise_session.exercise.should == @exercise
      end

      it "assigns the exercise in the exercise session" do
        get "show", :id=>@exercise.id
        assigns[:exercise].should == @exercise
      end

      it "redirects if an exercise is not in the exercise session" do
        @another_exercise = Factory.create :exercise  
        @current_user.plate.push(@another_exercise)
        get "show", :id=>@another_exercise.id
        response.should redirect_to(:action=>:already_doing_exercise, :id=>@exercise.id)
      end
    end

    context "the user is anonymous" do

      it "displays all sample exercises unconditionally (plate or no plate)" do
        @sample1 = Factory.create :exercise, :title=>'demo1'
        APP_CONFIG['demo_exercise_titles'].push(@sample1.title)
        @current_user.stub(:anonymous?).and_return(true)

        get "show", :id=>@sample1.id
        assigns[:exercise].should == @sample1
      end

      it "redirects for all exercises that are not sample exercises" do
        @not_sample = Factory.create :exercise
        @sample1 = Factory.create :exercise, :title=>'demo1'
        APP_CONFIG['demo_exercise_titles'].push(@sample1.title)
        @current_user.stub(:anonymous?).and_return(true)

        get "show", :id=>@not_sample.id
        response.should_not render_template('show')
      end
    end
 end
end

