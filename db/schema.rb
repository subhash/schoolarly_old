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

ActiveRecord::Schema.define(:version => 20100708082021) do

  create_table "academic_years", :force => true do |t|
    t.date     "start_date"
    t.date     "end_date"
    t.integer  "school_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "academic_years", ["school_id"], :name => "school_id"

  create_table "activities", :force => true do |t|
    t.integer  "position"
    t.integer  "assessment_tool_id"
    t.string   "description"
    t.decimal  "max_score",          :precision => 6, :scale => 2
    t.integer  "event_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "activities", ["assessment_tool_id"], :name => "assessment_tool_id"
  add_index "activities", ["event_id"], :name => "event_id"

  create_table "assessment_groups", :force => true do |t|
    t.integer  "assessment_type_id",                               :null => false
    t.integer  "klass_id",                                         :null => false
    t.decimal  "max_score",          :precision => 6, :scale => 2
    t.decimal  "weightage",          :precision => 5, :scale => 2
    t.integer  "academic_year_id",                                 :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "assessment_groups", ["assessment_type_id"], :name => "assessment_type_id"
  add_index "assessment_groups", ["klass_id"], :name => "klass_id"
  add_index "assessment_groups", ["academic_year_id"], :name => "academic_year_id"

  create_table "assessment_tool_names", :force => true do |t|
    t.string   "name",                                   :null => false
    t.string   "assessment_type_name", :default => "FA"
    t.integer  "school_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "assessment_tool_names", ["school_id"], :name => "school_id"

  create_table "assessment_tool_names_school_subjects", :id => false, :force => true do |t|
    t.integer "assessment_tool_name_id", :null => false
    t.integer "school_subject_id",       :null => false
  end

  add_index "assessment_tool_names_school_subjects", ["assessment_tool_name_id"], :name => "assessment_tool_name_id"
  add_index "assessment_tool_names_school_subjects", ["school_subject_id"], :name => "school_subject_id"

  create_table "assessment_tools", :force => true do |t|
    t.string   "name"
    t.integer  "assessment_id",                                              :null => false
    t.integer  "best_of",                                     :default => 1
    t.decimal  "weightage",     :precision => 5, :scale => 2
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "assessment_tools", ["assessment_id"], :name => "assessment_id"

  create_table "assessment_types", :force => true do |t|
    t.string   "name",                                     :null => false
    t.integer  "term",                                     :null => false
    t.decimal  "max_score",  :precision => 6, :scale => 2
    t.decimal  "weightage",  :precision => 5, :scale => 2
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "assessments", :force => true do |t|
    t.integer  "subject_id",          :null => false
    t.integer  "assessment_group_id", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "assessments", ["subject_id"], :name => "subject_id"
  add_index "assessments", ["assessment_group_id"], :name => "assessment_group_id"

  create_table "conversations", :force => true do |t|
    t.string   "subject",    :default => ""
    t.datetime "created_at",                 :null => false
  end

  create_table "event_series", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.integer  "frequency",   :default => 0
    t.string   "period",      :default => "once"
    t.integer  "user_id",                         :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "event_series", ["user_id"], :name => "user_id"

  create_table "event_series_users", :id => false, :force => true do |t|
    t.integer  "event_series_id", :null => false
    t.integer  "user_id",         :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "event_series_users", ["event_series_id", "user_id"], :name => "index_event_series_users_on_event_series_id_and_user_id", :unique => true
  add_index "event_series_users", ["user_id"], :name => "user_id"

  create_table "events", :force => true do |t|
    t.datetime "start_time"
    t.datetime "end_time"
    t.integer  "event_series_id", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "events", ["event_series_id"], :name => "event_series_id"

  create_table "klasses", :force => true do |t|
    t.integer  "level_id",   :null => false
    t.string   "division"
    t.integer  "school_id",  :null => false
    t.integer  "teacher_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "klasses", ["school_id"], :name => "school_id"
  add_index "klasses", ["teacher_id"], :name => "teacher_id"
  add_index "klasses", ["level_id"], :name => "level_id"

  create_table "leave_requests", :force => true do |t|
    t.integer  "parent_id",  :null => false
    t.date     "start_date"
    t.date     "end_date"
    t.string   "reason"
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "leave_requests", ["parent_id"], :name => "parent_id"

  create_table "levels", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mail", :force => true do |t|
    t.integer  "user_id",                                          :null => false
    t.integer  "message_id",                                       :null => false
    t.integer  "conversation_id"
    t.boolean  "read",                          :default => false
    t.boolean  "trashed",                       :default => false
    t.string   "mailbox",         :limit => 25
    t.datetime "created_at",                                       :null => false
  end

  add_index "mail", ["message_id"], :name => "message_id"
  add_index "mail", ["user_id"], :name => "user_id"
  add_index "mail", ["conversation_id"], :name => "conversation_id"

  create_table "messages", :force => true do |t|
    t.text     "body"
    t.string   "subject",         :default => ""
    t.text     "headers"
    t.integer  "sender_id",                          :null => false
    t.integer  "conversation_id"
    t.boolean  "sent",            :default => false
    t.datetime "created_at",                         :null => false
  end

  add_index "messages", ["sender_id"], :name => "sender_id"
  add_index "messages", ["conversation_id"], :name => "conversation_id"

  create_table "messages_recipients", :id => false, :force => true do |t|
    t.integer "message_id",   :null => false
    t.integer "recipient_id", :null => false
  end

  add_index "messages_recipients", ["message_id"], :name => "message_id"
  add_index "messages_recipients", ["recipient_id"], :name => "recipient_id"

  create_table "papers", :force => true do |t|
    t.integer  "klass_id"
    t.integer  "school_subject_id"
    t.integer  "teacher_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "papers", ["klass_id"], :name => "klass_id"
  add_index "papers", ["school_subject_id"], :name => "school_subject_id"
  add_index "papers", ["teacher_id"], :name => "teacher_id"

  create_table "papers_students", :id => false, :force => true do |t|
    t.integer  "student_id", :null => false
    t.integer  "paper_id",   :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "papers_students", ["student_id", "paper_id"], :name => "index_papers_students_on_student_id_and_paper_id", :unique => true
  add_index "papers_students", ["paper_id"], :name => "paper_id"

  create_table "parents", :force => true do |t|
    t.integer  "student_id", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "parents", ["student_id"], :name => "student_id"

  create_table "school_subjects", :force => true do |t|
    t.integer "school_id",  :null => false
    t.integer "subject_id", :null => false
  end

  add_index "school_subjects", ["school_id"], :name => "school_id"
  add_index "school_subjects", ["subject_id"], :name => "subject_id"

  create_table "schoolarly_admins", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "schools", :force => true do |t|
    t.string   "board",      :default => "CBSE"
    t.string   "fax"
    t.string   "website"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "scores", :force => true do |t|
    t.integer  "activity_id"
    t.integer  "student_id"
    t.decimal  "score",       :precision => 6, :scale => 2
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "scores", ["activity_id"], :name => "activity_id"
  add_index "scores", ["student_id"], :name => "student_id"

  create_table "students", :force => true do |t|
    t.integer  "school_id"
    t.string   "admission_number"
    t.string   "roll_number"
    t.string   "board_registration_number"
    t.string   "house"
    t.date     "date_of_birth"
    t.string   "mothers_name"
    t.string   "fathers_name"
    t.integer  "klass_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "students", ["school_id"], :name => "school_id"
  add_index "students", ["klass_id"], :name => "klass_id"

  create_table "subjects", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "teachers", :force => true do |t|
    t.integer  "school_id"
    t.text     "qualifications"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "teachers", ["school_id"], :name => "school_id"

  create_table "user_profiles", :force => true do |t|
    t.integer  "user_id",        :null => false
    t.string   "name"
    t.string   "address_line_1"
    t.string   "address_line_2"
    t.string   "city"
    t.string   "state"
    t.string   "country"
    t.string   "pincode"
    t.string   "phone_landline"
    t.string   "phone_mobile"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "user_profiles", ["user_id"], :name => "user_id"

  create_table "users", :force => true do |t|
    t.integer  "person_id",                          :null => false
    t.string   "person_type",                        :null => false
    t.string   "email"
    t.string   "crypted_password"
    t.string   "password_salt"
    t.string   "persistence_token",                  :null => false
    t.string   "single_access_token",                :null => false
    t.string   "perishable_token",                   :null => false
    t.integer  "login_count",         :default => 0, :null => false
    t.integer  "failed_login_count",  :default => 0, :null => false
    t.datetime "last_request_at"
    t.datetime "current_login_at"
    t.datetime "last_login_at"
    t.string   "current_login_ip"
    t.string   "last_login_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_foreign_key "academic_years", ["school_id"], "schools", ["id"], :name => "academic_years_ibfk_1"

  add_foreign_key "activities", ["assessment_tool_id"], "assessment_tools", ["id"], :name => "activities_ibfk_1"
  add_foreign_key "activities", ["event_id"], "events", ["id"], :name => "activities_ibfk_2"

  add_foreign_key "assessment_groups", ["assessment_type_id"], "assessment_types", ["id"], :name => "assessment_groups_ibfk_1"
  add_foreign_key "assessment_groups", ["klass_id"], "klasses", ["id"], :name => "assessment_groups_ibfk_2"
  add_foreign_key "assessment_groups", ["academic_year_id"], "academic_years", ["id"], :name => "assessment_groups_ibfk_3"

  add_foreign_key "assessment_tool_names", ["school_id"], "schools", ["id"], :name => "assessment_tool_names_ibfk_1"

  add_foreign_key "assessment_tool_names_school_subjects", ["assessment_tool_name_id"], "assessment_tool_names", ["id"], :name => "assessment_tool_names_school_subjects_ibfk_1"
  add_foreign_key "assessment_tool_names_school_subjects", ["school_subject_id"], "school_subjects", ["id"], :name => "assessment_tool_names_school_subjects_ibfk_2"

  add_foreign_key "assessment_tools", ["assessment_id"], "assessments", ["id"], :name => "assessment_tools_ibfk_1"

  add_foreign_key "assessments", ["subject_id"], "subjects", ["id"], :name => "assessments_ibfk_1"
  add_foreign_key "assessments", ["assessment_group_id"], "assessment_groups", ["id"], :name => "assessments_ibfk_2"

  add_foreign_key "event_series", ["user_id"], "users", ["id"], :name => "event_series_ibfk_1"

  add_foreign_key "event_series_users", ["event_series_id"], "event_series", ["id"], :name => "event_series_users_ibfk_1"
  add_foreign_key "event_series_users", ["user_id"], "users", ["id"], :name => "event_series_users_ibfk_2"

  add_foreign_key "events", ["event_series_id"], "event_series", ["id"], :name => "events_ibfk_1"

  add_foreign_key "klasses", ["school_id"], "schools", ["id"], :name => "klasses_ibfk_1"
  add_foreign_key "klasses", ["teacher_id"], "teachers", ["id"], :name => "klasses_ibfk_2"
  add_foreign_key "klasses", ["level_id"], "levels", ["id"], :name => "klasses_ibfk_3"

  add_foreign_key "leave_requests", ["parent_id"], "users", ["id"], :name => "leave_requests_ibfk_1"

  add_foreign_key "mail", ["message_id"], "messages", ["id"], :name => "mail_ibfk_1"
  add_foreign_key "mail", ["user_id"], "users", ["id"], :name => "mail_ibfk_2"
  add_foreign_key "mail", ["conversation_id"], "conversations", ["id"], :name => "mail_ibfk_3"

  add_foreign_key "messages", ["sender_id"], "users", ["id"], :name => "messages_ibfk_1"
  add_foreign_key "messages", ["conversation_id"], "conversations", ["id"], :name => "messages_ibfk_2"

  add_foreign_key "messages_recipients", ["message_id"], "messages", ["id"], :name => "messages_recipients_ibfk_1"
  add_foreign_key "messages_recipients", ["recipient_id"], "users", ["id"], :name => "messages_recipients_ibfk_2"

  add_foreign_key "papers", ["klass_id"], "klasses", ["id"], :name => "papers_ibfk_1"
  add_foreign_key "papers", ["school_subject_id"], "school_subjects", ["id"], :name => "papers_ibfk_2"
  add_foreign_key "papers", ["teacher_id"], "teachers", ["id"], :name => "papers_ibfk_3"

  add_foreign_key "papers_students", ["student_id"], "students", ["id"], :name => "papers_students_ibfk_1"
  add_foreign_key "papers_students", ["paper_id"], "papers", ["id"], :name => "papers_students_ibfk_2"

  add_foreign_key "parents", ["student_id"], "students", ["id"], :name => "parents_ibfk_1"

  add_foreign_key "school_subjects", ["school_id"], "schools", ["id"], :name => "school_subjects_ibfk_1"
  add_foreign_key "school_subjects", ["subject_id"], "subjects", ["id"], :name => "school_subjects_ibfk_2"

  add_foreign_key "scores", ["activity_id"], "activities", ["id"], :name => "scores_ibfk_1"
  add_foreign_key "scores", ["student_id"], "students", ["id"], :name => "scores_ibfk_2"

  add_foreign_key "students", ["school_id"], "schools", ["id"], :name => "students_ibfk_1"
  add_foreign_key "students", ["klass_id"], "klasses", ["id"], :name => "students_ibfk_2"

  add_foreign_key "teachers", ["school_id"], "schools", ["id"], :name => "teachers_ibfk_1"

  add_foreign_key "user_profiles", ["user_id"], "users", ["id"], :name => "user_profiles_ibfk_1"

end
