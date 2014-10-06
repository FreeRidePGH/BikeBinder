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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20141006031217) do

  create_table "answers", force: true do |t|
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
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.string   "default_value"
    t.string   "api_id"
    t.string   "display_type"
  end

  create_table "assignments", force: true do |t|
    t.integer  "bike_id"
    t.integer  "application_id"
    t.string   "application_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "assignments", ["application_id", "application_type"], name: "index_assignments_on_application"

  create_table "bike_brands", force: true do |t|
    t.string "name", null: false
  end

  add_index "bike_brands", ["name"], name: "index_bike_brands_on_name"

  create_table "bike_models", force: true do |t|
    t.string  "name",          null: false
    t.integer "bike_brand_id"
  end

  add_index "bike_models", ["bike_brand_id"], name: "index_bike_models_on_bike_brand_id"
  add_index "bike_models", ["name"], name: "index_bike_models_on_name"

  create_table "bikes", force: true do |t|
    t.string   "color"
    t.float    "value"
    t.float    "seat_tube_height"
    t.float    "top_tube_length"
    t.integer  "wheel_size"
    t.integer  "bike_model_id"
    t.string   "number_record"
    t.string   "quality"
    t.string   "condition"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "bikes", ["condition"], name: "index_bikes_on_condition"
  add_index "bikes", ["number_record"], name: "index_bikes_on_number_record"
  add_index "bikes", ["quality"], name: "index_bikes_on_quality"

  create_table "comments", force: true do |t|
    t.integer  "commentable_id",   default: 0
    t.string   "commentable_type", default: ""
    t.string   "title",            default: ""
    t.text     "body"
    t.string   "subject",          default: ""
    t.integer  "user_id",          default: 0,  null: false
    t.integer  "parent_id"
    t.integer  "lft"
    t.integer  "rgt"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "comments", ["commentable_id"], name: "index_comments_on_commentable_id"
  add_index "comments", ["user_id"], name: "index_comments_on_user_id"

  create_table "departures", force: true do |t|
    t.float    "value"
    t.integer  "disposition_id"
    t.string   "disposition_type"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  add_index "departures", ["disposition_id", "disposition_type"], name: "index_departures_on_disposition"

  create_table "dependencies", force: true do |t|
    t.integer  "question_id"
    t.integer  "question_group_id"
    t.string   "rule"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  create_table "dependency_conditions", force: true do |t|
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
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  create_table "destinations", force: true do |t|
    t.string   "name"
    t.string   "label"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "friendly_id_slugs", force: true do |t|
    t.string   "slug",                      null: false
    t.integer  "sluggable_id",              null: false
    t.string   "sluggable_type", limit: 40
    t.datetime "created_at"
  end

  add_index "friendly_id_slugs", ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type", unique: true
  add_index "friendly_id_slugs", ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id"
  add_index "friendly_id_slugs", ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type"

  create_table "hook_reservations", force: true do |t|
    t.integer  "bike_id"
    t.integer  "hook_id"
    t.string   "bike_state"
    t.string   "hook_state"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "hook_reservations", ["bike_id"], name: "index_hook_reservations_on_bike_id"
  add_index "hook_reservations", ["hook_id"], name: "index_hook_reservations_on_hook_id"

  create_table "hooks", force: true do |t|
    t.string   "number_record"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "hooks", ["number_record"], name: "index_hooks_on_number_record"

  create_table "hound_actions", force: true do |t|
    t.string   "action",          null: false
    t.string   "actionable_type", null: false
    t.integer  "actionable_id",   null: false
    t.integer  "user_id"
    t.string   "user_type"
    t.datetime "created_at"
    t.text     "changeset"
  end

  add_index "hound_actions", ["actionable_type", "actionable_id"], name: "index_hound_actions_on_actionable_type_and_actionable_id"
  add_index "hound_actions", ["user_type", "user_id"], name: "index_hound_actions_on_user_type_and_user_id"

  create_table "programs", force: true do |t|
    t.string   "name"
    t.string   "label"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "closed_at"
  end

  add_index "programs", ["label"], name: "index_programs_on_label", unique: true
  add_index "programs", ["name"], name: "index_programs_on_name"

  create_table "question_groups", force: true do |t|
    t.text     "text"
    t.text     "help_text"
    t.string   "reference_identifier"
    t.string   "data_export_identifier"
    t.string   "common_namespace"
    t.string   "common_identifier"
    t.string   "display_type"
    t.string   "custom_class"
    t.string   "custom_renderer"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.string   "api_id"
  end

  create_table "questions", force: true do |t|
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
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.integer  "correct_answer_id"
    t.string   "api_id"
  end

  create_table "response_sets", force: true do |t|
    t.integer  "user_id"
    t.integer  "survey_id"
    t.string   "access_code"
    t.datetime "started_at"
    t.datetime "completed_at"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.string   "api_id"
    t.integer  "surveyable_id"
    t.string   "surveyable_type"
    t.integer  "surveyable_process_id"
    t.string   "surveyable_process_type"
  end

  add_index "response_sets", ["access_code"], name: "response_sets_ac_idx", unique: true

  create_table "responses", force: true do |t|
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
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.integer  "survey_section_id"
    t.string   "api_id"
  end

  add_index "responses", ["survey_section_id"], name: "index_responses_on_survey_section_id"

  create_table "signatures", force: true do |t|
    t.string   "uname",      null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "signatures", ["uname"], name: "index_signatures_on_uname"

  create_table "survey_sections", force: true do |t|
    t.integer  "survey_id"
    t.string   "title"
    t.text     "description"
    t.string   "reference_identifier"
    t.string   "data_export_identifier"
    t.string   "common_namespace"
    t.string   "common_identifier"
    t.integer  "display_order"
    t.string   "custom_class"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "surveys", force: true do |t|
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
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.integer  "display_order"
    t.string   "api_id"
  end

  add_index "surveys", ["access_code"], name: "surveys_ac_idx", unique: true

  create_table "users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "failed_attempts",        default: 0
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.integer  "group",                  default: 0
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  add_index "users", ["unlock_token"], name: "index_users_on_unlock_token", unique: true

  create_table "validation_conditions", force: true do |t|
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
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  create_table "validations", force: true do |t|
    t.integer  "answer_id"
    t.string   "rule"
    t.string   "message"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "versions", force: true do |t|
    t.string   "item_type",  null: false
    t.integer  "item_id",    null: false
    t.string   "event",      null: false
    t.string   "whodunnit"
    t.text     "object"
    t.datetime "created_at"
  end

  add_index "versions", ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id"

end
