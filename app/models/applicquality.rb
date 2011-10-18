# == Schema Information
#
# Table name: applicqualities
#
#  id              :integer         not null, primary key
#  application_id  :integer
#  quality_id      :integer
#  position        :integer
#  applicant_score :integer         default(0)
#  created_at      :datetime
#  updated_at      :datetime
#

class Applicquality < ActiveRecord::Base

  attr_accessible :applicant_score, :position
  
  belongs_to :application
  
  validates	:application_id,		:presence	=> true
  validates	:quality_id,			:presence 	=> true
  validates	:applicant_score,		:presence	=> true
  						
end
