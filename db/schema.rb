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

ActiveRecord::Schema.define(:version => 20090908072727) do

  create_table "klasses", :force => true do |t|
    t.enum     "level",      :limit => [:"Pre-school", :"L.K.G", :"U.K.G", :Mont1, :Mont2, :Mont3, :"1", :"2", :"3", :"4", :"5", :"6", :"7", :"8", :"9", :"10", :"11", :"12"]
    t.string   "division"
    t.integer  "school_id",                                                                                                                                                    :null => false
    t.integer  "year"
    t.integer  "teacher_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "klasses", ["school_id"], :name => "school_id"
  add_index "klasses", ["teacher_id"], :name => "teacher_id"

  create_table "klasses_subjects", :id => false, :force => true do |t|
    t.integer "klass_id",   :null => false
    t.integer "subject_id", :null => false
  end

  add_index "klasses_subjects", ["klass_id", "subject_id"], :name => "index_klasses_subjects_on_klass_id_and_subject_id", :unique => true
  add_index "klasses_subjects", ["subject_id"], :name => "subject_id"

  create_table "parents", :force => true do |t|
    t.integer  "student_id", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "parents", ["student_id"], :name => "student_id"

  create_table "qualifications", :force => true do |t|
    t.string   "degree"
    t.string   "subject"
    t.string   "university"
    t.date     "date"
    t.integer  "teacher_id", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "qualifications", ["teacher_id"], :name => "teacher_id"

  create_table "schools", :force => true do |t|
    t.string   "name"
    t.enum     "board",      :limit => [:cbse, :icse, :state, :others], :default => :cbse
    t.string   "fax"
    t.string   "website"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "schools_subjects", :id => false, :force => true do |t|
    t.integer "school_id",  :null => false
    t.integer "subject_id", :null => false
  end

  add_index "schools_subjects", ["school_id", "subject_id"], :name => "index_schools_subjects_on_school_id_and_subject_id", :unique => true
  add_index "schools_subjects", ["subject_id"], :name => "subject_id"

  create_table "student_enrollments", :force => true do |t|
    t.integer  "student_id",       :null => false
    t.integer  "klass_id",         :null => false
    t.string   "admission_number"
    t.string   "roll_number"
    t.date     "enrollment_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "student_enrollments", ["student_id"], :name => "student_id"
  add_index "student_enrollments", ["klass_id"], :name => "klass_id"

  create_table "students", :force => true do |t|
    t.integer  "school_id"
    t.string   "admission_number"
    t.integer  "current_enrollment_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "students", ["school_id"], :name => "school_id"
  add_index "students", ["current_enrollment_id"], :name => "current_enrollment_id"

  create_table "subjects", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "teacher_allotments", :force => true do |t|
    t.integer  "teacher_id",     :null => false
    t.integer  "subject_id",     :null => false
    t.integer  "klass_id",       :null => false
    t.date     "allotment_date"
    t.boolean  "is_current"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "teacher_allotments", ["teacher_id"], :name => "teacher_id"
  add_index "teacher_allotments", ["subject_id"], :name => "subject_id"
  add_index "teacher_allotments", ["klass_id"], :name => "klass_id"

  create_table "teachers", :force => true do |t|
    t.integer  "school_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "teachers", ["school_id"], :name => "school_id"

  create_table "users", :force => true do |t|
    t.string   "first_name"
    t.string   "middle_name"
    t.string   "last_name"
    t.string   "address_line1"
    t.string   "address_line2"
    t.string   "city"
    t.string   "state"
    t.string   "country"
    t.string   "pincode"
    t.string   "phone_landline"
    t.string   "phone_mobile"
    t.string   "email"
    t.string   "hashed_password"
    t.string   "salt"
    t.integer  "person_id"
    t.string   "person_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_foreign_key "klasses", ["school_id"], "schools", ["id"], :name => "klasses_ibfk_1"
  add_foreign_key "klasses", ["teacher_id"], "teachers", ["id"], :name => "klasses_ibfk_2"

  add_foreign_key "klasses_subjects", ["klass_id"], "klasses", ["id"], :name => "klasses_subjects_ibfk_1"
  add_foreign_key "klasses_subjects", ["subject_id"], "subjects", ["id"], :name => "klasses_subjects_ibfk_2"

  add_foreign_key "parents", ["student_id"], "students", ["id"], :name => "parents_ibfk_1"

  add_foreign_key "qualifications", ["teacher_id"], "teachers", ["id"], :name => "qualifications_ibfk_1"

  add_foreign_key "schools_subjects", ["school_id"], "schools", ["id"], :name => "schools_subjects_ibfk_1"
  add_foreign_key "schools_subjects", ["subject_id"], "subjects", ["id"], :name => "schools_subjects_ibfk_2"

  add_foreign_key "student_enrollments", ["student_id"], "students", ["id"], :name => "student_enrollments_ibfk_1"
  add_foreign_key "student_enrollments", ["klass_id"], "klasses", ["id"], :name => "student_enrollments_ibfk_2"

  add_foreign_key "students", ["school_id"], "schools", ["id"], :name => "students_ibfk_1"
  add_foreign_key "students", ["current_enrollment_id"], "student_enrollments", ["id"], :name => "students_ibfk_2"

  add_foreign_key "teacher_allotments", ["teacher_id"], "teachers", ["id"], :name => "teacher_allotments_ibfk_1"
  add_foreign_key "teacher_allotments", ["subject_id"], "subjects", ["id"], :name => "teacher_allotments_ibfk_2"
  add_foreign_key "teacher_allotments", ["klass_id"], "klasses", ["id"], :name => "teacher_allotments_ibfk_3"

  add_foreign_key "teachers", ["school_id"], "schools", ["id"], :name => "teachers_ibfk_1"

end
