# == Schema Information
#
# Table name: requirements
#
#  id          :integer         not null, primary key
#  plan_id     :integer
#  requirement :string(255)
#  position    :integer
#  created_at  :datetime
#  updated_at  :datetime
#

class Requirement < ActiveRecord::Base

  belongs_to :plan
  has_many :applicrequirements
  
  acts_as_list :scope => :plan
  
  attr_accessible :requirement
  
  validates	:plan_id,	:presence 	=> true
  validates	:requirement,	:presence 	=> true,
  				:uniqueness	=> { :scope => :plan_id },
  				:length 	=> { :maximum => 50 } 				
  
  
end
