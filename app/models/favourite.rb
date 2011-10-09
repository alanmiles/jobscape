# == Schema Information
#
# Table name: favourites
#
#  id         :integer         not null, primary key
#  user_id    :integer
#  favourite  :string(255)
#  position   :integer
#  created_at :datetime
#  updated_at :datetime
#

class Favourite < ActiveRecord::Base

  attr_accessible :favourite, :position
  
  belongs_to :user
  
  acts_as_list :scope => :user
  
  validates :user_id,		:presence 	=> true
  validates :favourite,		:length		=> { :maximum => 50 },
  				:uniqueness	=> { :scope => :user_id, :message => "is already in the list" }

end
