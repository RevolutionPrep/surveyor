# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20101201183800) do

  create_table "components", :force => true do |t|
    t.text     "value"
    t.integer  "question_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "position"
    t.integer  "user_id"
  end

  add_index "components", ["question_id"], :name => "index_components_on_question_id"
  add_index "components", ["user_id"], :name => "index_components_on_user_id"

  create_table "question_results", :force => true do |t|
    t.integer  "survey_result_id"
    t.integer  "question_id"
    t.integer  "component_id"
    t.integer  "rating_label_id"
    t.text     "response"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
  end

  add_index "question_results", ["component_id"], :name => "index_question_results_on_component_id"
  add_index "question_results", ["question_id"], :name => "index_question_results_on_question_id"
  add_index "question_results", ["rating_label_id"], :name => "index_question_results_on_rating_label_id"
  add_index "question_results", ["survey_result_id"], :name => "index_question_results_on_survey_result_id"
  add_index "question_results", ["user_id"], :name => "index_question_results_on_user_id"

  create_table "questions", :force => true do |t|
    t.integer  "section_id"
    t.text     "statement"
    t.string   "type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "position"
    t.boolean  "multiple_answers",    :default => false
    t.boolean  "user_entered_answer", :default => false
    t.boolean  "required",            :default => false
    t.integer  "user_id"
    t.integer  "rating_scale_id"
    t.string   "handle"
  end

  add_index "questions", ["rating_scale_id"], :name => "index_questions_on_rating_scale_id"
  add_index "questions", ["section_id"], :name => "index_questions_on_section_id"
  add_index "questions", ["user_id"], :name => "index_questions_on_user_id"

  create_table "rating_labels", :force => true do |t|
    t.string   "key"
    t.string   "value"
    t.integer  "rating_scale_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id",         :null => false
  end

  add_index "rating_labels", ["rating_scale_id"], :name => "index_rating_labels_on_rating_scale_id"
  add_index "rating_labels", ["user_id"], :name => "index_rating_labels_on_user_id"

  create_table "rating_scales", :force => true do |t|
    t.string   "name"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "rating_scales", ["user_id"], :name => "index_rating_scales_on_user_id"

  create_table "sections", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.integer  "survey_id",   :null => false
  end

  add_index "sections", ["survey_id"], :name => "index_sections_on_survey_id"
  add_index "sections", ["user_id"], :name => "index_sections_on_user_id"

  create_table "survey_results", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.boolean  "completed",    :default => false
    t.text     "redirect_url"
    t.integer  "survey_id",                       :null => false
    t.string   "set_key"
  end

  add_index "survey_results", ["survey_id"], :name => "index_survey_results_on_survey_id"
  add_index "survey_results", ["user_id"], :name => "index_survey_results_on_user_id"

  create_table "surveys", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.string   "api_key"
    t.string   "title",       :default => "", :null => false
    t.text     "description",                 :null => false
  end

  add_index "surveys", ["user_id"], :name => "index_surveys_on_user_id"

  create_table "user_sessions", :force => true do |t|
    t.string   "username"
    t.string   "password"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "username"
    t.string   "crypted_password"
    t.string   "password_salt"
    t.string   "persistence_token"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
