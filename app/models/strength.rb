# == Schema Information
#
# Table name: strengths
#
#  id         :integer         not null, primary key
#  user_id    :integer
#  strength   :string(255)
#  position   :integer
#  created_at :datetime
#  updated_at :datetime
#

class Strength < ActiveRecord::Base

  attr_accessible :strength, :position
  
  belongs_to :user
  
  acts_as_list :scope => :user
  
  validates :user_id,		:presence 	=> true
  validates :strength,		:presence	=> true,
  				:length		=> { :maximum => 50 },
  				:uniqueness	=> { :scope => :user_id, :message => "is already in the list" }

end
