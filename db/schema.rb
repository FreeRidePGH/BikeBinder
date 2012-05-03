# encoding: UTF-8
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

ActiveRecord::Schema.define(:version => 20120503052836) do

  create_table "answers", :force => true do |t|
    t.integer  "question_id"
    t.text     "text"
    t.text     "short_text"
    t.text     "help_text"
    t.integer  "weight"
    t.string   "response_class"
    t.string   "reference_identifier"
    t.string   "data_export_identifier"
    t.string   "common_namespace"
    t.string   "common_identifier"
    t.integer  "display_order"
    t.boolean  "is_exclusive"
    t.integer  "display_length"
    t.string   "custom_class"
    t.string   "custom_renderer"
    t.datetime "created_at",             :null => false
    t.datetime "updated_at",             :null => false
    t.string   "default_value"
    t.string   "api_id"
    t.string   "display_type"
  end

  create_table "bikes", :force => true do |t|
    t.string   "color"
    t.float    "value"
    t.float    "seat_tube_height"
    t.float    "top_tube_length"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "departed_at"
    t.string   "mfg"
    t.string   "model"
    t.string   "number"
    t.integer  "project_id"
    t.string   "location_state"
  end

  add_index "bikes", ["number"], :name => "index_bikes_on_number"
  add_index "bikes", ["project_id"], :name => "index_bikes_on_project_id"

  create_table "comments", :force => true do |t|
    t.integer  "commentable_id",   :default => 0
    t.string   "commentable_type", :default => ""
    t.string   "title",            :default => ""
    t.text     "body",             :default => ""
    t.string   "subject",          :default => ""
    t.integer  "user_id",          :default => 0,  :null => false
    t.integer  "parent_id"
    t.integer  "lft"
    t.integer  "rgt"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "comments", ["commentable_id"], :name => "index_comments_on_commentable_id"
  add_index "comments", ["user_id"], :name => "index_comments_on_user_id"

  create_table "dependencies", :force => true do |t|
    t.integer  "question_id"
    t.integer  "question_group_id"
    t.string   "rule"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  create_table "dependency_conditions", :force => true do |t|
    t.integer  "dependency_id"
    t.string   "rule_key"
    t.integer  "question_id"
    t.string   "operator"
    t.integer  "answer_id"
    t.datetime "datetime_value"
    t.integer  "integer_value"
    t.float    "float_value"
    t.string   "unit"
    t.text     "text_value"
    t.string   "string_value"
    t.string   "response_other"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  create_table "friendly_id_slugs", :force => true do |t|
    t.string   "slug",                         :null => false
    t.integer  "sluggable_id",                 :null => false
    t.string   "sluggable_type", :limit => 40
    t.datetime "created_at"
  end

  add_index "friendly_id_slugs", ["slug", "sluggable_type"], :name => "index_friendly_id_slugs_on_slug_and_sluggable_type", :unique => true
  add_index "friendly_id_slugs", ["sluggable_id"], :name => "index_friendly_id_slugs_on_sluggable_id"
  add_index "friendly_id_slugs", ["sluggable_type"], :name => "index_friendly_id_slugs_on_sluggable_type"

  create_table "hooks", :force => true do |t|
    t.string   "number"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "bike_id"
  end

  add_index "hooks", ["bike_id"], :name => "index_hooks_on_bike_id"
  add_index "hooks", ["number"], :name => "index_hooks_on_number"

  create_table "programs", :force => true do |t|
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "cosed_at"
    t.string   "slug"
    t.integer  "max_open"
    t.integer  "max_total"
    t.integer  "project_category_id"
  end

  add_index "programs", ["project_category_id"], :name => "index_programs_on_project_category_id"
  add_index "programs", ["slug"], :name => "index_programs_on_slug"

  create_table "project_categories", :force => true do |t|
    t.string   "name"
    t.string   "project_type"
    t.integer  "max_programs"
    t.string   "slug"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "project_categories", ["slug"], :name => "index_project_categories_on_slug"

  create_table "project_detail_versions", :force => true do |t|
    t.string   "item_type",  :null => false
    t.integer  "item_id",    :null => false
    t.string   "event",      :null => false
    t.string   "whodunnit"
    t.text     "object"
    t.datetime "created_at"
    t.string   "state"
  end

  add_index "project_detail_versions", ["item_type", "item_id", "state"], :name => "index_project_detail_versions_on_item_type_and_item_id_and_state"

  create_table "project_eab_details", :force => true do |t|
    t.integer  "proj_id"
    t.string   "proj_type"
    t.string   "state"
    t.string   "status_state"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "project_scrap_details", :force => true do |t|
    t.integer  "proj_id"
    t.string   "proj_type"
    t.string   "state"
    t.string   "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "project_youth_details", :force => true do |t|
    t.integer  "proj_id"
    t.string   "proj_type"
    t.string   "state"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "projects", :force => true do |t|
    t.string   "type"
    t.integer  "prog_id"
    t.string   "prog_type"
    t.string   "label"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "closed_at"
    t.integer  "project_category_id"
    t.string   "state"
    t.string   "completion_state"
  end

  add_index "projects", ["label"], :name => "index_projects_on_label", :unique => true
  add_index "projects", ["prog_id"], :name => "index_projects_on_prog_id"
  add_index "projects", ["project_category_id"], :name => "index_projects_on_project_category_id"
  add_index "projects", ["type"], :name => "index_projects_on_type"

  create_table "question_groups", :force => true do |t|
    t.text     "text"
    t.text     "help_text"
    t.string   "reference_identifier"
    t.string   "data_export_identifier"
    t.string   "common_namespace"
    t.string   "common_identifier"
    t.string   "display_type"
    t.string   "custom_class"
    t.string   "custom_renderer"
    t.datetime "created_at",             :null => false
    t.datetime "updated_at",             :null => false
    t.string   "api_id"
  end

  create_table "questions", :force => true do |t|
    t.integer  "survey_section_id"
    t.integer  "question_group_id"
    t.text     "text"
    t.text     "short_text"
    t.text     "help_text"
    t.string   "pick"
    t.string   "reference_identifier"
    t.string   "data_export_identifier"
    t.string   "common_namespace"
    t.string   "common_identifier"
    t.integer  "display_order"
    t.string   "display_type"
    t.boolean  "is_mandatory"
    t.integer  "display_width"
    t.string   "custom_class"
    t.string   "custom_renderer"
    t.datetime "created_at",             :null => false
    t.datetime "updated_at",             :null => false
    t.integer  "correct_answer_id"
    t.string   "api_id"
  end

  create_table "response_sets", :force => true do |t|
    t.integer  "user_id"
    t.integer  "survey_id"
    t.string   "access_code"
    t.datetime "started_at"
    t.datetime "completed_at"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
    t.string   "api_id"
  end

  add_index "response_sets", ["access_code"], :name => "response_sets_ac_idx", :unique => true

  create_table "responses", :force => true do |t|
    t.integer  "response_set_id"
    t.integer  "question_id"
    t.integer  "answer_id"
    t.datetime "datetime_value"
    t.integer  "integer_value"
    t.float    "float_value"
    t.string   "unit"
    t.text     "text_value"
    t.string   "string_value"
    t.string   "response_other"
    t.string   "response_group"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
    t.integer  "survey_section_id"
    t.string   "api_id"
  end

  add_index "responses", ["survey_section_id"], :name => "index_responses_on_survey_section_id"

  create_table "survey_sections", :force => true do |t|
    t.integer  "survey_id"
    t.string   "title"
    t.text     "description"
    t.string   "reference_identifier"
    t.string   "data_export_identifier"
    t.string   "common_namespace"
    t.string   "common_identifier"
    t.integer  "display_order"
    t.string   "custom_class"
    t.datetime "created_at",             :null => false
    t.datetime "updated_at",             :null => false
  end

  create_table "surveys", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.string   "access_code"
    t.string   "reference_identifier"
    t.string   "data_export_identifier"
    t.string   "common_namespace"
    t.string   "common_identifier"
    t.datetime "active_at"
    t.datetime "inactive_at"
    t.string   "css_url"
    t.string   "custom_class"
    t.datetime "created_at",             :null => false
    t.datetime "updated_at",             :null => false
    t.integer  "display_order"
    t.string   "api_id"
  end

  add_index "surveys", ["access_code"], :name => "surveys_ac_idx", :unique => true

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

  create_table "validation_conditions", :force => true do |t|
    t.integer  "validation_id"
    t.string   "rule_key"
    t.string   "operator"
    t.integer  "question_id"
    t.integer  "answer_id"
    t.datetime "datetime_value"
    t.integer  "integer_value"
    t.float    "float_value"
    t.string   "unit"
    t.text     "text_value"
    t.string   "string_value"
    t.string   "response_other"
    t.string   "regexp"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  create_table "validations", :force => true do |t|
    t.integer  "answer_id"
    t.string   "rule"
    t.string   "message"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "versions", :force => true do |t|
    t.string   "item_type",  :null => false
    t.integer  "item_id",    :null => false
    t.string   "event",      :null => false
    t.string   "whodunnit"
    t.text     "object"
    t.datetime "created_at"
  end

  add_index "versions", ["item_type", "item_id"], :name => "index_versions_on_item_type_and_item_id"

end
