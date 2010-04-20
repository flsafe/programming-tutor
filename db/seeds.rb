# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#   
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Major.create(:name => 'Daley', :city => cities.first)
user = User.create! :username=>'Frank',:email=>'user@mail.com', :password=>'password', :password_confirmation=>'password'

ex1 = Exercise.create! :title=>"Implementing A Singly Linked List", :description=>"This exercise comes up often in phone screenings! Get practice implemeting a simple linked list in one hour!",  :average_grade=>66.1
ex1.grade_sheets.create! :grade=>100, :user=>user, :resource=>ex1

ex2 = Exercise.create! :title=>"Adding A Tail Pointer", :description=>"A queue with your linked list? A tail pointer will let you do that efficiently! Get practice maintaining a tail pointer",  :average_grade=>77.2
ex2.grade_sheets.create! :grade=>90, :user=>user, :resource=>ex2

set = ExerciseSet.create! :title=>"Linked List Levity", :description=>"Learn how to implement a basic linked list", :exercises=>[ex1, ex2]
set.grade_sheets.create! :grade=>95, :user=>user, :resource=>set

