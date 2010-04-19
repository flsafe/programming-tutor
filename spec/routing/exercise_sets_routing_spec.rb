require 'spec_helper'

describe ExerciseSetsController do
  describe "routing" do
    it "recognizes and generates #index" do
      { :get => "/exercise_sets" }.should route_to(:controller => "exercise_sets", :action => "index")
    end

    it "recognizes and generates #new" do
      { :get => "/exercise_sets/new" }.should route_to(:controller => "exercise_sets", :action => "new")
    end

    it "recognizes and generates #show" do
      { :get => "/exercise_sets/1" }.should route_to(:controller => "exercise_sets", :action => "show", :id => "1")
    end

    it "recognizes and generates #edit" do
      { :get => "/exercise_sets/1/edit" }.should route_to(:controller => "exercise_sets", :action => "edit", :id => "1")
    end

    it "recognizes and generates #create" do
      { :post => "/exercise_sets" }.should route_to(:controller => "exercise_sets", :action => "create") 
    end

    it "recognizes and generates #update" do
      { :put => "/exercise_sets/1" }.should route_to(:controller => "exercise_sets", :action => "update", :id => "1") 
    end

    it "recognizes and generates #destroy" do
      { :delete => "/exercise_sets/1" }.should route_to(:controller => "exercise_sets", :action => "destroy", :id => "1") 
    end
  end
end
