# == Schema Information
#
# Table name: reviewgoals
#
#  id                      :integer         not null, primary key
#  reviewresponsibility_id :integer
#  goal_id                 :integer
#  achieved                :boolean         default(FALSE)
#  created_at              :datetime
#  updated_at              :datetime
#

class Reviewgoal < ActiveRecord::Base

  belongs_to :reviewresponsibility
  belongs_to :goal
  
  attr_accessible :achieved
  
  validates	:reviewresponsibility_id,	:presence	=> true
  validates	:goal_id,			:presence	=> true
end
