# == Schema Information
#
# Table name: dislikes
#
#  id         :integer         not null, primary key
#  user_id    :integer
#  dislike    :string(255)
#  position   :integer
#  created_at :datetime
#  updated_at :datetime
#

class Dislike < ActiveRecord::Base

  attr_accessible :dislike, :position
  
  belongs_to :user
  
  acts_as_list :scope => :user
  
  validates :user_id,		:presence 	=> true
  validates :dislike,		:length		=> { :maximum => 50 },
  				:uniqueness	=> { :scope => :user_id, :message => "is already in the list" }


end
