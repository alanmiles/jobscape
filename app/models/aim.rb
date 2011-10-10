# == Schema Information
#
# Table name: aims
#
#  id         :integer         not null, primary key
#  user_id    :integer
#  aim        :string(255)
#  position   :integer
#  created_at :datetime
#  updated_at :datetime
#

class Aim < ActiveRecord::Base

  attr_accessible :aim, :position
  
  belongs_to :user
  
  acts_as_list :scope => :user
  
  validates :user_id,		:presence 	=> true
  validates :aim,		:presence	=> true,
  				:length		=> { :maximum => 50 },
  				:uniqueness	=> { :scope => :user_id, :message => "is already in the list" }

end
