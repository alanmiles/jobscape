# == Schema Information
#
# Table name: qualifications
#
#  id            :integer         not null, primary key
#  user_id       :integer
#  qualification :string(255)
#  position      :integer
#  created_at    :datetime
#  updated_at    :datetime
#

class Qualification < ActiveRecord::Base

  attr_accessible :qualification, :position
  
  belongs_to :user
  
  acts_as_list :scope => :user
  
  validates :user_id,		:presence 	=> true
  validates :qualification,	:length		=> { :maximum => 50 },
  				:uniqueness	=> { :scope => :user_id, :message => "is already in the list" }

end
