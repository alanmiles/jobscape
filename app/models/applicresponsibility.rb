# == Schema Information
#
# Table name: applicresponsibilities
#
#  id                :integer         not null, primary key
#  application_id    :integer
#  responsibility_id :integer
#  position          :integer
#  applicant_score   :integer         default(0)
#  created_at        :datetime
#  updated_at        :datetime
#

class Applicresponsibility < ActiveRecord::Base

  belongs_to :application
  belongs_to :responsibility
  
  attr_accessible :applicant_score, :position
  
  RESPONSIBILITY_SCORES = [
    ["No training or experience", 0],
    ["Trained but no experience", 1],
    ["Some experience", 2],
    ["Lots of experience", 3]
  ]
  
  validates	:application_id,		:presence	=> true
  validates	:responsibility_id,		:presence 	=> true
  validates	:applicant_score,		:presence	=> true
  						
end
