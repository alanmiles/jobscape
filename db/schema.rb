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

ActiveRecord::Schema.define(:version => 20111107142318) do

  create_table "achievements", :force => true do |t|
    t.integer  "user_id"
    t.string   "achievement"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "aims", :force => true do |t|
    t.integer  "user_id"
    t.string   "aim"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "applications", :force => true do |t|
    t.integer  "vacancy_id"
    t.integer  "user_id"
    t.integer  "next_action",            :default => 0
    t.boolean  "submitted",              :default => false
    t.datetime "submission_date"
    t.integer  "requirements_score",     :default => 0
    t.integer  "qualities_score",        :default => 0
    t.integer  "portrait_score",         :default => 0
    t.boolean  "employer_shortlist",     :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "personal_statement"
    t.integer  "responsibilities_score", :default => 0
  end

  create_table "applicqualities", :force => true do |t|
    t.integer  "application_id"
    t.integer  "quality_id"
    t.integer  "position"
    t.integer  "applicant_score", :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "applicrequirements", :force => true do |t|
    t.integer  "application_id"
    t.integer  "requirement_id"
    t.integer  "position"
    t.integer  "applicant_score", :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "applicresponsibilities", :force => true do |t|
    t.integer  "application_id"
    t.integer  "responsibility_id"
    t.integer  "position"
    t.integer  "applicant_score",   :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "businesses", :force => true do |t|
    t.string   "name"
    t.string   "address"
    t.string   "city"
    t.string   "country"
    t.float    "latitude"
    t.float    "longitude"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "sector_id"
  end

  create_table "characteristics", :force => true do |t|
    t.integer  "user_id"
    t.string   "characteristic"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "departments", :force => true do |t|
    t.integer  "business_id"
    t.string   "name"
    t.integer  "manager_id"
    t.integer  "deputy_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "dislikes", :force => true do |t|
    t.integer  "user_id"
    t.string   "dislike"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "employees", :force => true do |t|
    t.integer  "user_id"
    t.integer  "business_id"
    t.boolean  "officer",     :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "ref"
    t.boolean  "left",        :default => false
  end

  add_index "employees", ["business_id"], :name => "index_employees_on_business_id"
  add_index "employees", ["user_id", "business_id"], :name => "index_employees_on_user_id_and_business_id", :unique => true
  add_index "employees", ["user_id"], :name => "index_employees_on_user_id"

  create_table "evaluations", :force => true do |t|
    t.integer  "responsibility_id"
    t.integer  "profits",           :default => 0
    t.integer  "customers",         :default => 0
    t.integer  "staff",             :default => 0
    t.integer  "processes",         :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "favourites", :force => true do |t|
    t.integer  "user_id"
    t.string   "favourite"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

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

  create_table "invitations", :force => true do |t|
    t.integer  "business_id"
    t.string   "name"
    t.string   "email"
    t.string   "security_code"
    t.integer  "inviter_id"
    t.integer  "invitee_id"
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
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "department_id"
  end

  create_table "limitations", :force => true do |t|
    t.integer  "user_id"
    t.string   "limitation"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "occupations", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "occupations", ["name"], :name => "index_occupations_on_name"

  create_table "outlines", :force => true do |t|
    t.integer  "job_id"
    t.text     "role",       :default => "Your role is to "
    t.text     "qualities",  :default => "To do this job well, you need "
    t.text     "importance", :default => "The job is important to the organization because "
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "pams", :force => true do |t|
    t.integer  "quality_id"
    t.string   "grade"
    t.string   "descriptor"
    t.integer  "updated_by"
    t.boolean  "approved",   :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "placements", :force => true do |t|
    t.integer  "user_id"
    t.integer  "job_id"
    t.boolean  "current",     :default => true
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "started_job"
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

  create_table "portraits", :force => true do |t|
    t.integer  "user_id"
    t.boolean  "worked_before", :default => false
    t.boolean  "right_to_work", :default => false
    t.string   "notes"
    t.boolean  "public",        :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "previousjobs", :force => true do |t|
    t.integer  "user_id"
    t.string   "job"
    t.integer  "years",      :default => 0
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "qualifications", :force => true do |t|
    t.integer  "user_id"
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

  create_table "references", :force => true do |t|
    t.integer  "user_id"
    t.string   "name"
    t.integer  "relationship",    :default => 4
    t.string   "role"
    t.string   "location"
    t.string   "address"
    t.string   "phone"
    t.string   "email"
    t.integer  "portrait_rating", :default => 7
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "requirements", :force => true do |t|
    t.integer  "plan_id"
    t.string   "requirement"
    t.integer  "position"
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

  create_table "reviewgoals", :force => true do |t|
    t.integer  "reviewresponsibility_id"
    t.integer  "goal_id"
    t.boolean  "achieved",                :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "reviewqualities", :force => true do |t|
    t.integer  "review_id"
    t.integer  "quality_id"
    t.integer  "position"
    t.integer  "reviewer_score", :default => 0
    t.integer  "adjusted_score", :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "reviewresponsibilities", :force => true do |t|
    t.integer  "review_id"
    t.integer  "responsibility_id"
    t.integer  "position"
    t.integer  "rating_value"
    t.integer  "total_goals"
    t.integer  "achieved_goals",    :default => 0
    t.float    "achievement_score", :default => 0.0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "reviews", :force => true do |t|
    t.integer  "reviewee_id"
    t.integer  "reviewer_id"
    t.string   "reviewer_name"
    t.string   "reviewer_email"
    t.string   "secret_code"
    t.integer  "job_id"
    t.integer  "responsibilities_score",    :default => 0
    t.integer  "attributes_score",          :default => 0
    t.string   "achievements"
    t.string   "problems"
    t.string   "observations"
    t.string   "change_responsibilities"
    t.string   "change_goals"
    t.string   "change_attributes"
    t.string   "plan"
    t.boolean  "responsibilities_complete", :default => false
    t.boolean  "qualities_complete",        :default => false
    t.boolean  "comments_complete",         :default => false
    t.boolean  "completed",                 :default => false
    t.datetime "completion_date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "placement_id"
  end

  add_index "reviews", ["reviewee_id"], :name => "index_reviews_on_reviewee_id"
  add_index "reviews", ["reviewer_id"], :name => "index_reviews_on_reviewer_id"

  create_table "sectors", :force => true do |t|
    t.string   "sector"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "strengths", :force => true do |t|
    t.integer  "user_id"
    t.string   "strength"
    t.integer  "position"
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
    t.integer  "account",            :default => 1
    t.boolean  "terms",              :default => false
    t.float    "latitude"
    t.float    "longitude"
    t.string   "address"
    t.string   "city"
    t.string   "country"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true

  create_table "vacancies", :force => true do |t|
    t.integer  "job_id"
    t.integer  "sector_id"
    t.integer  "quantity",                                     :default => 1
    t.integer  "annual_salary"
    t.decimal  "hourly_rate",    :precision => 5, :scale => 2
    t.boolean  "full_time",                                    :default => true
    t.boolean  "voluntary",                                    :default => false
    t.date     "close_date"
    t.boolean  "filled",                                       :default => false
    t.string   "notes"
    t.string   "contact_person"
    t.string   "contact_email"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
