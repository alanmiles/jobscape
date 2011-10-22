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
  belongs_to :quality
  
  ATTRIBUTE_SCORES = [
    ["It doesn't sound like me", 0],
    ["I'll be OK with experience", 1],
    ["I'm pretty good", 2],
    ["One of my key strengths", 3]
  ]
  
  validates	:application_id,		:presence	=> true
  validates	:quality_id,			:presence 	=> true
  validates	:applicant_score,		:presence	=> true
  						
end
