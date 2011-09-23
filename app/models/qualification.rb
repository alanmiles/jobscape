# == Schema Information
#
# Table name: qualifications
#
#  id            :integer         not null, primary key
#  plan_id       :integer
#  qualification :string(255)
#  position      :integer
#  created_at    :datetime
#  updated_at    :datetime
#

class Qualification < ActiveRecord::Base

  belongs_to :plan
  
  acts_as_list :scope => :plan
  
  attr_accessible :qualification
  
  validates	:plan_id,	:presence 	=> true
  validates	:qualification,	:presence 	=> true,
  				:uniqueness	=> { :scope => :plan_id },
  				:length 	=> { :maximum => 50 } 				
  
  
end
