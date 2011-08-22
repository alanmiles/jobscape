class Occupation < ActiveRecord::Base

  attr_accessible :name
  
  validates :name, 	:presence 	=> true,
  			:length		=> { :maximum => 30 }

  default_scope :order => 'occupations.name'
end

# == Schema Information
#
# Table name: occupations
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

