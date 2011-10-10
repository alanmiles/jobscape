# == Schema Information
#
# Table name: characteristics
#
#  id             :integer         not null, primary key
#  user_id        :integer
#  characteristic :string(255)
#  position       :integer
#  created_at     :datetime
#  updated_at     :datetime
#

class Characteristic < ActiveRecord::Base

  attr_accessible :characteristic, :position
  
  belongs_to :user
  
  acts_as_list :scope => :user
  
  validates :user_id,		:presence 	=> true
  validates :characteristic,	:presence 	=> true,
  				:length		=> { :maximum => 140 },
  				:uniqueness	=> { :scope => :user_id, :message => "is already in the list" }

end
