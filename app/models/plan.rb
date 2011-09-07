# == Schema Information
#
# Table name: plans
#
#  id                  :integer         not null, primary key
#  job_id              :integer
#  responsibilities    :boolean         default(FALSE)
#  goals               :boolean         default(FALSE)
#  personal_attributes :boolean         default(FALSE)
#  recruitment_factors :boolean         default(FALSE)
#  summary             :boolean         default(FALSE)
#  evaluation          :boolean         default(FALSE)
#  job_value           :integer
#  last_edited_by      :integer
#  created_at          :datetime
#  updated_at          :datetime
#

class Plan < ActiveRecord::Base

  belongs_to :job
  
  validates	:job_id,  	:presence 		=> true,
                                :uniqueness		=> true
end
