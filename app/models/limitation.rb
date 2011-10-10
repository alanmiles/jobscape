# == Schema Information
#
# Table name: limitations
#
#  id         :integer         not null, primary key
#  user_id    :integer
#  limitation :string(255)
#  position   :integer
#  created_at :datetime
#  updated_at :datetime
#

class Limitation < ActiveRecord::Base
  
  attr_accessible :limitation, :position
  
  belongs_to :user
  
  acts_as_list :scope => :user
  
  validates :user_id,		:presence 	=> true
  validates :limitation,	:presence 	=> true,
  				:length		=> { :maximum => 50 },
  				:uniqueness	=> { :scope => :user_id, :message => "is already in the list" }

end
