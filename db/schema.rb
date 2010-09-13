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

ActiveRecord::Schema.define(:version => 20100912202825) do

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0
    t.integer  "attempts",   :default => 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

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
    t.integer  "average_seconds"
  end

  create_table "figures", :force => true do |t|
    t.integer  "exercise_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
  end

  create_table "grade_sheets", :force => true do |t|
    t.integer  "user_id"
    t.integer  "exercise_id"
    t.float    "grade"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "unit_test_results"
    t.text     "src_code"
    t.integer  "time_taken"
  end

  create_table "hints", :force => true do |t|
    t.integer "exercise_id"
    t.text    "text"
  end

  create_table "job_results", :force => true do |t|
    t.integer  "user_id"
    t.integer  "exercise_id"
    t.string   "job_type"
    t.string   "data"
    t.string   "error_message"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "performance_statistics", :force => true do |t|
    t.integer  "user_id"
    t.integer  "exercise_id"
    t.string   "name"
    t.float    "value"
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

  create_table "solution_templates", :force => true do |t|
    t.integer  "exercise_id"
    t.text     "src_code"
    t.string   "src_language"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "taggings", :force => true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "taggable_type"
    t.string   "context"
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id"], :name => "index_taggings_on_tag_id"
  add_index "taggings", ["taggable_id", "taggable_type", "context"], :name => "index_taggings_on_taggable_id_and_taggable_type_and_context"

  create_table "tags", :force => true do |t|
    t.string "name"
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
