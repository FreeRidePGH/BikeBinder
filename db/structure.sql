CREATE TABLE "schema_migrations" ("version" varchar(255) NOT NULL);
CREATE UNIQUE INDEX "unique_schema_migrations" ON "schema_migrations" ("version");
CREATE TABLE "answers" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "question_id" integer, "text" text, "short_text" text, "help_text" text, "weight" integer, "response_class" varchar(255), "reference_identifier" varchar(255), "data_export_identifier" varchar(255), "common_namespace" varchar(255), "common_identifier" varchar(255), "display_order" integer, "is_exclusive" boolean, "display_length" integer, "custom_class" varchar(255), "custom_renderer" varchar(255), "created_at" datetime NOT NULL, "updated_at" datetime NOT NULL, "default_value" varchar(255), "api_id" varchar(255), "display_type" varchar(255));
CREATE TABLE "assignments" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "bike_id" integer, "application_id" integer, "application_type" varchar(255), "created_at" datetime, "updated_at" datetime);
CREATE INDEX "index_assignments_on_application" ON "assignments" ("application_id", "application_type");
CREATE TABLE "bike_brands" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "name" varchar(255) NOT NULL);
CREATE INDEX "index_bike_brands_on_name" ON "bike_brands" ("name");
CREATE TABLE "bike_models" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "name" varchar(255) NOT NULL, "bike_brand_id" integer);
CREATE INDEX "index_bike_models_on_bike_brand_id" ON "bike_models" ("bike_brand_id");
CREATE INDEX "index_bike_models_on_name" ON "bike_models" ("name");
CREATE TABLE "bikes" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "color" varchar(255), "value" float, "seat_tube_height" float, "top_tube_length" float, "wheel_size" integer, "bike_model_id" integer, "number_record" varchar(255), "quality" varchar(255), "condition" varchar(255), "created_at" datetime, "updated_at" datetime);
CREATE INDEX "index_bikes_on_condition" ON "bikes" ("condition");
CREATE INDEX "index_bikes_on_number_record" ON "bikes" ("number_record");
CREATE INDEX "index_bikes_on_quality" ON "bikes" ("quality");
CREATE TABLE "comments" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "commentable_id" integer DEFAULT 0, "commentable_type" varchar(255) DEFAULT '', "title" varchar(255) DEFAULT '', "body" text, "subject" varchar(255) DEFAULT '', "user_id" integer DEFAULT 0 NOT NULL, "parent_id" integer, "lft" integer, "rgt" integer, "created_at" datetime, "updated_at" datetime);
CREATE INDEX "index_comments_on_commentable_id" ON "comments" ("commentable_id");
CREATE INDEX "index_comments_on_user_id" ON "comments" ("user_id");
CREATE TABLE "departures" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "value" float, "disposition_id" integer, "disposition_type" varchar(255), "created_at" datetime NOT NULL, "updated_at" datetime NOT NULL);
CREATE INDEX "index_departures_on_disposition" ON "departures" ("disposition_id", "disposition_type");
CREATE TABLE "dependencies" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "question_id" integer, "question_group_id" integer, "rule" varchar(255), "created_at" datetime NOT NULL, "updated_at" datetime NOT NULL);
CREATE TABLE "dependency_conditions" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "dependency_id" integer, "rule_key" varchar(255), "question_id" integer, "operator" varchar(255), "answer_id" integer, "datetime_value" datetime, "integer_value" integer, "float_value" float, "unit" varchar(255), "text_value" text, "string_value" varchar(255), "response_other" varchar(255), "created_at" datetime NOT NULL, "updated_at" datetime NOT NULL);
CREATE TABLE "destinations" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "name" varchar(255), "label" varchar(255), "created_at" datetime NOT NULL, "updated_at" datetime NOT NULL);
CREATE TABLE "friendly_id_slugs" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "slug" varchar(255) NOT NULL, "sluggable_id" integer NOT NULL, "sluggable_type" varchar(40), "created_at" datetime);
CREATE UNIQUE INDEX "index_friendly_id_slugs_on_slug_and_sluggable_type" ON "friendly_id_slugs" ("slug", "sluggable_type");
CREATE INDEX "index_friendly_id_slugs_on_sluggable_id" ON "friendly_id_slugs" ("sluggable_id");
CREATE INDEX "index_friendly_id_slugs_on_sluggable_type" ON "friendly_id_slugs" ("sluggable_type");
CREATE TABLE "hook_reservations" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "bike_id" integer, "hook_id" integer, "bike_state" varchar(255), "hook_state" varchar(255), "created_at" datetime NOT NULL, "updated_at" datetime NOT NULL);
CREATE INDEX "index_hook_reservations_on_bike_id" ON "hook_reservations" ("bike_id");
CREATE INDEX "index_hook_reservations_on_hook_id" ON "hook_reservations" ("hook_id");
CREATE TABLE "hooks" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "number_record" varchar(255), "created_at" datetime, "updated_at" datetime);
CREATE INDEX "index_hooks_on_number_record" ON "hooks" ("number_record");
CREATE TABLE "hound_actions" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "action" varchar(255) NOT NULL, "actionable_type" varchar(255) NOT NULL, "actionable_id" integer NOT NULL, "user_id" integer, "user_type" varchar(255), "created_at" datetime, "changeset" text);
CREATE INDEX "index_hound_actions_on_actionable_type_and_actionable_id" ON "hound_actions" ("actionable_type", "actionable_id");
CREATE INDEX "index_hound_actions_on_user_type_and_user_id" ON "hound_actions" ("user_type", "user_id");
CREATE TABLE "programs" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "name" varchar(255), "label" varchar(255), "created_at" datetime, "updated_at" datetime, "closed_at" datetime);
CREATE UNIQUE INDEX "index_programs_on_label" ON "programs" ("label");
CREATE INDEX "index_programs_on_name" ON "programs" ("name");
CREATE TABLE "question_groups" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "text" text, "help_text" text, "reference_identifier" varchar(255), "data_export_identifier" varchar(255), "common_namespace" varchar(255), "common_identifier" varchar(255), "display_type" varchar(255), "custom_class" varchar(255), "custom_renderer" varchar(255), "created_at" datetime NOT NULL, "updated_at" datetime NOT NULL, "api_id" varchar(255));
CREATE TABLE "questions" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "survey_section_id" integer, "question_group_id" integer, "text" text, "short_text" text, "help_text" text, "pick" varchar(255), "reference_identifier" varchar(255), "data_export_identifier" varchar(255), "common_namespace" varchar(255), "common_identifier" varchar(255), "display_order" integer, "display_type" varchar(255), "is_mandatory" boolean, "display_width" integer, "custom_class" varchar(255), "custom_renderer" varchar(255), "created_at" datetime NOT NULL, "updated_at" datetime NOT NULL, "correct_answer_id" integer, "api_id" varchar(255));
CREATE TABLE "response_sets" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "user_id" integer, "survey_id" integer, "access_code" varchar(255), "started_at" datetime, "completed_at" datetime, "created_at" datetime NOT NULL, "updated_at" datetime NOT NULL, "api_id" varchar(255), "surveyable_id" integer, "surveyable_type" varchar(255), "surveyable_process_id" integer, "surveyable_process_type" varchar(255));
CREATE UNIQUE INDEX "response_sets_ac_idx" ON "response_sets" ("access_code");
CREATE TABLE "responses" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "response_set_id" integer, "question_id" integer, "answer_id" integer, "datetime_value" datetime, "integer_value" integer, "float_value" float, "unit" varchar(255), "text_value" text, "string_value" varchar(255), "response_other" varchar(255), "response_group" varchar(255), "created_at" datetime NOT NULL, "updated_at" datetime NOT NULL, "survey_section_id" integer, "api_id" varchar(255));
CREATE INDEX "index_responses_on_survey_section_id" ON "responses" ("survey_section_id");
CREATE TABLE "signatures" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "uname" varchar(255) NOT NULL, "created_at" datetime NOT NULL, "updated_at" datetime NOT NULL);
CREATE INDEX "index_signatures_on_uname" ON "signatures" ("uname");
CREATE TABLE "survey_sections" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "survey_id" integer, "title" varchar(255), "description" text, "reference_identifier" varchar(255), "data_export_identifier" varchar(255), "common_namespace" varchar(255), "common_identifier" varchar(255), "display_order" integer, "custom_class" varchar(255), "created_at" datetime NOT NULL, "updated_at" datetime NOT NULL);
CREATE TABLE "surveys" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "title" varchar(255), "description" text, "access_code" varchar(255), "reference_identifier" varchar(255), "data_export_identifier" varchar(255), "common_namespace" varchar(255), "common_identifier" varchar(255), "active_at" datetime, "inactive_at" datetime, "css_url" varchar(255), "custom_class" varchar(255), "created_at" datetime NOT NULL, "updated_at" datetime NOT NULL, "display_order" integer, "api_id" varchar(255));
CREATE UNIQUE INDEX "surveys_ac_idx" ON "surveys" ("access_code");
CREATE TABLE "validation_conditions" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "validation_id" integer, "rule_key" varchar(255), "operator" varchar(255), "question_id" integer, "answer_id" integer, "datetime_value" datetime, "integer_value" integer, "float_value" float, "unit" varchar(255), "text_value" text, "string_value" varchar(255), "response_other" varchar(255), "regexp" varchar(255), "created_at" datetime NOT NULL, "updated_at" datetime NOT NULL);
CREATE TABLE "validations" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "answer_id" integer, "rule" varchar(255), "message" varchar(255), "created_at" datetime NOT NULL, "updated_at" datetime NOT NULL);
CREATE TABLE "versions" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "item_type" varchar(255) NOT NULL, "item_id" integer NOT NULL, "event" varchar(255) NOT NULL, "whodunnit" varchar(255), "object" text, "created_at" datetime);
CREATE INDEX "index_versions_on_item_type_and_item_id" ON "versions" ("item_type", "item_id");
CREATE TABLE "users" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "email" varchar(255) DEFAULT '' NOT NULL, "encrypted_password" varchar(255) DEFAULT '' NOT NULL, "reset_password_token" varchar(255), "reset_password_sent_at" datetime, "remember_created_at" datetime, "sign_in_count" integer DEFAULT 0, "current_sign_in_at" datetime, "last_sign_in_at" datetime, "current_sign_in_ip" varchar(255), "last_sign_in_ip" varchar(255), "created_at" datetime, "updated_at" datetime, "failed_attempts" integer DEFAULT 0, "unlock_token" varchar(255), "locked_at" datetime, "group" integer DEFAULT 0);
CREATE UNIQUE INDEX "index_users_on_email" ON "users" ("email");
CREATE UNIQUE INDEX "index_users_on_reset_password_token" ON "users" ("reset_password_token");
CREATE UNIQUE INDEX "index_users_on_unlock_token" ON "users" ("unlock_token");
INSERT INTO schema_migrations (version) VALUES ('20130721165753');

INSERT INTO schema_migrations (version) VALUES ('20140905041347');

INSERT INTO schema_migrations (version) VALUES ('20140929000814');

INSERT INTO schema_migrations (version) VALUES ('20141004143056');

INSERT INTO schema_migrations (version) VALUES ('20141005200409');

INSERT INTO schema_migrations (version) VALUES ('20141006031217');

