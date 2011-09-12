# == Schema Information
#
# Table name: qualities
#
#  id           :integer         not null, primary key
#  quality      :string(255)
#  approved     :boolean         default(FALSE)
#  created_by   :integer
#  business_id  :integer
#  updated_by   :integer
#  seen         :boolean         default(FALSE)
#  removed      :boolean         default(FALSE)
#  removal_date :date
#  created_at   :datetime
#  updated_at   :datetime
#

class Quality < ActiveRecord::Base

  attr_accessible :quality, :approved, :seen, :removed, :created_by
  
  validates	:quality,	:presence 	=> true,
                		:length		=> { :maximum => 50 },
  				:uniqueness	=> { :case_sensitive => false }
  validates	:created_by,	:presence	=> true,
  				:numericality	=> { :integer => true }
  
end
