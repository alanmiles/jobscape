# == Schema Information
#
# Table name: applicrequirements
#
#  id              :integer         not null, primary key
#  application_id  :integer
#  requirement_id  :integer
#  position        :integer
#  applicant_score :integer         default(0)
#  created_at      :datetime
#  updated_at      :datetime
#

class Applicrequirement < ActiveRecord::Base

  attr_accessible :applicant_score, :position
  
  belongs_to :application
  
  validates	:application_id,		:presence	=> true
  validates	:requirement_id,		:presence 	=> true
  validates	:applicant_score,		:presence	=> true
  						
end
