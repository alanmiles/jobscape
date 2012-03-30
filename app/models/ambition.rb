class Ambition < ActiveRecord::Base


# == Schema Information
#
# Table name: ambitions
#
#  id         :integer         not null, primary key
#  user_id    :integer
#  ambition   :string(255)
#  created_at :datetime
#  updated_at :datetime
#

  belongs_to :user
  has_many :targets, :dependent => :destroy

  attr_accessible :ambition
  
  validates	:user_id,		:presence		=> true
  validates	:ambition,		:presence 		=> true,
  					:length			=> { :maximum => 100 },
  					:uniqueness		=> { :scope => :user_id,
  					  			     :case_sensitive => false,
  					  			     :message => " has already been entered." }
  
end
