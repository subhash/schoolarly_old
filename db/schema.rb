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

ActiveRecord::Schema.define(:version => 20100702162810) do

  create_table "academic_years", :force => true do |t|
    t.date     "start_date"
    t.date     "end_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "activities", :force => true do |t|
    t.integer  "assessment_tool_id"
    t.string   "description"
    t.integer  "max_score",          :limit => 10, :precision => 10, :scale => 0
    t.integer  "event_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "activities", ["assessment_tool_id"], :name => "assessment_tool_id"
  add_index "activities", ["event_id"], :name => "event_id"

  create_table "assessment_tool_types", :force => true do |t|
    t.string   "name"
    t.integer  "school_subject_id"
    t.integer  "assessment_type_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "assessment_tool_types", ["school_subject_id"], :name => "school_subject_id"
  add_index "assessment_tool_types", ["assessment_type_id"], :name => "assessment_type_id"

  create_table "assessment_tools", :force => true do |t|
    t.integer  "assessment_tool_type_id"
    t.integer  "assessment_id"
    t.integer  "ignore_worst"
    t.integer  "weightage",               :limit => 10, :precision => 10, :scale => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "assessment_tools", ["assessment_tool_type_id"], :name => "assessment_tool_type_id"
  add_index "assessment_tools", ["assessment_id"], :name => "assessment_id"

  create_table "assessment_types", :force => true do |t|
    t.string   "name"
    t.integer  "term"
    t.integer  "max_score",  :limit => 10, :precision => 10, :scale => 0
    t.decimal  "weightage",                :precision => 5,  :scale => 2
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "assessments", :force => true do |t|
    t.integer  "assessment_type_id"
    t.integer  "klass_id"
    t.integer  "subject_id"
    t.integer  "weightage",          :limit => 10, :precision => 10, :scale => 0
    t.integer  "academic_year_id"
    t.integer  "teacher_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "assessments", ["assessment_type_id"], :name => "assessment_type_id"
  add_index "assessments", ["klass_id"], :name => "klass_id"
  add_index "assessments", ["subject_id"], :name => "subject_id"
  add_index "assessments", ["academic_year_id"], :name => "academic_year_id"
  add_index "assessments", ["teacher_id"], :name => "teacher_id"

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
    t.integer  "subject_id"
    t.integer  "teacher_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "papers", ["klass_id"], :name => "klass_id"
  add_index "papers", ["subject_id"], :name => "subject_id"
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

# Could not dump table "schools" because of following ActiveRecord::StatementInvalid
#   Mysql::Error: Can't create/write to file 'C:\DOCUME~1\Subhash\LOCALS~1\Temp\#sql_1430_0.MYD' (Errcode: 13): describe `schools`

# Could not dump table "scores" because of following ActiveRecord::StatementInvalid
#   Mysql::Error: Can't create/write to file 'C:\DOCUME~1\Subhash\LOCALS~1\Temp\#sql_1430_0.MYD' (Errcode: 13): describe `scores`

