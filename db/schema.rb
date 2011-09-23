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

ActiveRecord::Schema.define(:version => 20110922202118) do

  create_table "businesses", :force => true do |t|
    t.string   "name"
    t.string   "address"
    t.string   "city"
    t.string   "country"
    t.float    "latitude"
    t.float    "longitude"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "employees", :force => true do |t|
    t.integer  "user_id"
    t.integer  "business_id"
    t.boolean  "officer",     :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "employees", ["business_id"], :name => "index_employees_on_business_id"
  add_index "employees", ["user_id", "business_id"], :name => "index_employees_on_user_id_and_business_id", :unique => true
  add_index "employees", ["user_id"], :name => "index_employees_on_user_id"

  create_table "goals", :force => true do |t|
    t.integer  "responsibility_id"
    t.string   "objective"
    t.boolean  "removed",           :default => false
    t.date     "removal_date"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "jobqualities", :force => true do |t|
    t.integer  "plan_id"
    t.integer  "quality_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "position"
  end

  add_index "jobqualities", ["plan_id", "quality_id"], :name => "index_jobqualities_on_plan_id_and_quality_id", :unique => true
  add_index "jobqualities", ["plan_id"], :name => "index_jobqualities_on_plan_id"
  add_index "jobqualities", ["quality_id"], :name => "index_jobqualities_on_quality_id"

  create_table "jobs", :force => true do |t|
    t.string   "job_title"
    t.integer  "business_id"
    t.integer  "occupation_id"
    t.boolean  "vacancy",       :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "occupations", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "occupations", ["name"], :name => "index_occupations_on_name"

  create_table "pams", :force => true do |t|
    t.integer  "quality_id"
    t.string   "grade"
    t.string   "descriptor"
    t.integer  "updated_by"
    t.boolean  "approved",   :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "plans", :force => true do |t|
    t.integer  "job_id"
    t.boolean  "responsibilities",    :default => false
    t.boolean  "goals",               :default => false
    t.boolean  "personal_attributes", :default => false
    t.boolean  "recruitment_factors", :default => false
    t.boolean  "summary",             :default => false
    t.boolean  "evaluation",          :default => false
    t.integer  "job_value"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "qualifications", :force => true do |t|
    t.integer  "plan_id"
    t.string   "qualification"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "qualities", :force => true do |t|
    t.string   "quality"
    t.boolean  "approved",     :default => false
    t.integer  "created_by"
    t.integer  "updated_by"
    t.boolean  "seen",         :default => false
    t.boolean  "removed",      :default => false
    t.date     "removal_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "responsibilities", :force => true do |t|
    t.integer  "plan_id"
    t.string   "definition"
    t.integer  "rating",       :default => 0
    t.boolean  "removed",      :default => false
    t.date     "removal_date"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "encrypted_password"
    t.string   "salt"
    t.boolean  "admin",              :default => false
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true

end
