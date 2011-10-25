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
    ["One of my biggest strengths", 3]
  ]
  
  validates	:application_id,		:presence	=> true
  validates	:quality_id,			:presence 	=> true
  validates	:applicant_score,		:presence	=> true


  def rating
    if applicant_score == 0
      return "It doesn't sound like me."
    elsif applicant_score == 1
      return "I'll be OK with experience."
    elsif applicant_score == 2
      return "I'm pretty good."
    else
      return "That's one of my biggest strengths."
    end
  end  						
end
