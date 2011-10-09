# == Schema Information
#
# Table name: achievements
#
#  id          :integer         not null, primary key
#  user_id     :integer
#  achievement :string(255)
#  position    :integer
#  created_at  :datetime
#  updated_at  :datetime
#

class Achievement < ActiveRecord::Base

  attr_accessible :achievement, :position
  
  belongs_to :user
  
  acts_as_list :scope => :user
  
  validates :user_id,		:presence 	=> true
  validates :achievement,	:length		=> { :maximum => 140 },
  				:uniqueness	=> { :scope => :user_id, :message => "is already in the list" }
end
