# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20100427183850) do

  create_table "exercise_sets", :force => true do |t|
    t.string   "title"
    t.string   "description"
    t.float    "average_grade"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "exercises", :force => true do |t|
    t.integer  "exercise_set_id"
    t.string   "title"
    t.string   "description"
    t.text     "problem"
    t.text     "tutorial"
    t.text     "hints"
    t.integer  "minutes"
    t.float    "average_grade"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "grade_sheets", :force => true do |t|
    t.integer  "user_id"
    t.integer  "exercise_id"
    t.float    "grade"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "set_grade_sheets", :force => true do |t|
    t.integer  "user_id"
    t.integer  "exercise_set_id"
    t.float    "grade"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "unit_tests", :force => true do |t|
    t.integer  "exercise_id"
    t.string   "src_language"
    t.text     "src_code"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_sessions", :force => true do |t|
    t.string   "username"
    t.string   "password"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "username"
    t.string   "email"
    t.string   "crypted_password"
    t.string   "password_salt"
    t.string   "persistence_token"
    t.integer  "roles_mask",        :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
